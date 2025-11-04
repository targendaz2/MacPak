import Alamofire
import Foundation
import Testing

@testable import MacPakCore

// MARK: - URLProtocol stub
final class StubURLProtocol: URLProtocol {
    struct ResponseSpec {
        var statusCode: Int
        var headers: [String: String] = [:]
        var body: Data = Data()
        var redirectLocation: URL? = nil
    }

    static var responses: [URL: ResponseSpec] = [:]

    override class func canInit(with request: URLRequest) -> Bool {
        guard let scheme = request.url?.scheme?.lowercased() else { return false }
        return scheme == "http" || scheme == "https"
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url, let spec = StubURLProtocol.responses[url] else {
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: Data())
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        if let redirect = spec.redirectLocation {
            let response = HTTPURLResponse(
                url: url,
                statusCode: 301,
                httpVersion: "HTTP/1.1",
                headerFields: ["Location": redirect.absoluteString]
            )!
            client?.urlProtocol(
                self,
                wasRedirectedTo: URLRequest(url: redirect),
                redirectResponse: response
            )
            client?.urlProtocolDidFinishLoading(self)
            return
        }

        let response = HTTPURLResponse(
            url: url,
            statusCode: spec.statusCode,
            httpVersion: "HTTP/1.1",
            headerFields: spec.headers
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: spec.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

private func makeSession() -> Session {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [StubURLProtocol.self]
    return Session(configuration: config)
}

@Suite("Downloader tests", .serialized)
struct DownloaderTests {

    @Test("Successful download writes bytes to destination")
    func testSuccessfulDownload() async throws {
        // Arrange
        let url = URL(string: "https://example.com/file.bin")!
        let bytes = Data([0x00, 0x01, 0x02, 0x03])
        StubURLProtocol.responses = [
            url: .init(
                statusCode: 200,
                headers: ["Content-Length": String(bytes.count)],
                body: bytes
            )
        ]
        let session = makeSession()
        let downloader = Downloader(session: session)

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString
        )
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let destination = tempDir.appendingPathComponent("file.bin")

        // Act
        try await downloader.download(from: url, to: destination)

        // Assert
        let written = try Data(contentsOf: destination)
        #expect(written == bytes)

        // Cleanup
        try? FileManager.default.removeItem(at: tempDir)
    }

    @Test("HTTP error surfaces as error")
    func testHTTPError() async throws {
        // Arrange
        let url = URL(string: "https://example.com/404")!
        StubURLProtocol.responses = [
            url: .init(statusCode: 404, headers: [:], body: Data())
        ]
        let session = makeSession()
        let downloader = Downloader(session: session)

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString
        )
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let destination = tempDir.appendingPathComponent("notfound")

        // Act & Assert
        do {
            try await downloader.download(from: url, to: destination)
            Issue.record("Expected error, but download succeeded")
        } catch {
            // Success: any error is fine, Alamofire wraps validation failures
            #expect(true)
        }

        // Cleanup
        try? FileManager.default.removeItem(at: tempDir)
    }

    @Test("Redirection is followed to final URL")
    func testRedirectFollowed() async throws {
        // Arrange
        let original = URL(string: "https://example.com/redirect")!
        let final = URL(string: "https://example.com/final.bin")!
        let bytes = Data([0xAA, 0xBB])

        StubURLProtocol.responses = [
            original: .init(
                statusCode: 301,
                headers: ["Location": final.absoluteString],
                body: Data(),
                redirectLocation: final
            ),
            final: .init(
                statusCode: 200,
                headers: ["Content-Length": String(bytes.count)],
                body: bytes
            ),
        ]

        let session = makeSession()
        let downloader = Downloader(session: session)

        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(
            UUID().uuidString
        )
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        let destination = tempDir.appendingPathComponent("final.bin")

        // Act
        try await downloader.download(from: original, to: destination)

        // Assert
        let written = try Data(contentsOf: destination)
        #expect(written == bytes)

        // Cleanup
        try? FileManager.default.removeItem(at: tempDir)
    }
}
