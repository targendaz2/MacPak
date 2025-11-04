//
//  AppBundleProvider.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation
import SemVer

/// A provider that contributes a macOS app bundle to the package.
public struct AppBundleProvider: Provider {
    public let type = "appBundle"
    public let version = Version("0.1.0")!
    public let description =
        "Contributes a macOS app bundle from a specified source to the package."
    
    private let services: ProviderServices

    public func materialize(from declaration: ComponentDeclaration, context: BuildContext)
        async throws
        -> MaterializedComponent
    {
        guard let source = declaration.arguments["source"]?.value as? String else {
            throw ProviderError.missingArgument("source")
        }

        guard let sourceURL = URL(string: source) else {
            throw ProviderError.invalidArgument("source", "Invalid URL format")
        }

        guard let finalURL = try? await resolveURL(sourceURL) else {
            throw ProviderError.invalidArgument("source", "Could not resolve final URL")
        }

        switch finalURL.pathExtension.lowercased() {
        case ".app":
            return MaterializedComponent(
                path: finalURL,
                type: .appBundle,
                metadata: ["sourceURL": finalURL.absoluteString]
            )
        default:
            throw ProviderError.invalidArgument(
                "source",
                "Unsupported file type: \(finalURL.pathExtension)"
            )
        }
    }

    private func resolveURL(_ url: URL) async throws -> URL {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"

        let (_, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse,
            let finalURL = httpResponse.url
        {
            return finalURL
        } else if let finalURL = response.url {
            return finalURL
        } else {
            throw URLError(.badURL)
        }
    }
}
