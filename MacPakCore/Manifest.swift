//
//  Manifest.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/26/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation
import SemVer

public struct Manifest: Decodable {
    /// The package declaration.
    public var package: PackageDeclaration
    
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

/// Metadata about the package.
public struct PackageDeclaration: Decodable {
    /// The name of the package.
    public let name: String
    
    /// The version of the package.
    public let version: Version
    
    /// The unique identifier for the package.
    public let identifier: String
}

/// A declaration of a component within the package.
public struct ComponentDeclaration: Decodable {
    /// The name of the component.
    public let name: String
    
    /// The type of provider to use for this component.
    public let providerType: String
    
    /// The arguments specific to the provider.
    public let arguments: [String: AnyCodable]
}

