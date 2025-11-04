//
//  Manifest.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/26/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation
import SemVer

public struct Manifest: Codable {
    /// The name of the package.
    public let name: String
    
    /// The version of the package.
    public let version: Version
    
    /// The unique identifier for the package.
    public let identifier: String
    
    /// The list of component declarations.
    public var components: [ComponentDeclaration]
    
    /// Loads a manifest from the specified URL.
    public static func load(from url: URL) throws -> Self {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        decoder.semverVersionDecodingStrategy = .string
        return try decoder.decode(Self.self, from: data)
    }
}

