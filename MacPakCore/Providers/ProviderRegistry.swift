//
//  ProviderRegistry.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation

/// Registry for managing different providers
public final class ProviderRegistry {
    /// Singleton instance of the ProviderRegistry
    public static let shared = ProviderRegistry()

    /// Registered providers mapped by their type identifier
    public var providers: [String: Provider] = [:]

    private init() {}

    /// Registers a provider in the registry
    public func register(_ provider: Provider) {
        providers[type(of: provider).type] = provider
    }

    /// Retrieves a provider by its type identifier
    public func provider(for type: String) -> Provider? {
        return providers[type]
    }
}
