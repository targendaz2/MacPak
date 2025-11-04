//
//  Downloader.swift
//  MacPakCore
//
//  Created by David Rosenberg on 11/3/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Alamofire
import Foundation

public struct Downloader {
    private let session: Session

    public init(session: Session = AF) {
        self.session = session
    }

    public func download(from url: URL, to destinationURL: URL) async throws {
        // Define a destination that writes directly to the provided destinationURL
        let destination: DownloadRequest.Destination = { _, _ in
            (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        // Perform the download with retry policy, follow redirects, and validate the response
        let request = session.download(url, interceptor: .retryPolicy, to: destination)
            .redirect(using: .follow)
            .validate()

        // Await the download to finish and ensure the file is moved to destinationURL
        let fileURL = try await request.serializingDownloadedFileURL().value
        
        // Optionally verify the final location matches the destination
        guard fileURL == destinationURL else {
            throw AFError.explicitlyCancelled
        }
    }
}
