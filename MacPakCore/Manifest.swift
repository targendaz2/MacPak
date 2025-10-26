//
//  Manifest.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/26/25.
//  Copyright © 2025 DGR Dev. All rights reserved.
//

import Foundation
import SemVer

public struct Manifest: Decodable {
    public var package: PackageDeclaration
    public var components: [ComponentDeclaration]
    
    public static func load(from url: URL) throws -> Self {
        let data = try Data(contentsOf: url)
        let decoder = PropertyListDecoder()
        return try decoder.decode(Self.self, from: data)
    }
}

public struct PackageDeclaration: Decodable {
    public let name: String
    public let version: Version
}

public struct ComponentDeclaration: Decodable {
    public let name: String
    public let providerType: String
    public let arguments: [String: AnyCodable]
}
