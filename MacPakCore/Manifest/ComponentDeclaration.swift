//
//  ComponentDeclaration.swift
//  MacPakCore
//
//  Created by David Rosenberg on 11/2/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation

/// A declaration of a component within the package.
public struct ComponentDeclaration: Codable {    
    /// The type of provider to use for this component.
    public let providerType: String
    
    /// The arguments specific to the provider.
    public let arguments: [String: AnyCodable]
}
