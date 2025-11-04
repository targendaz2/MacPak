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
    /// Registered providers mapped by their type identifier
    private var providers: [String: Provider] = [:]

    init(defaultProviders: [Provider] = []) {
        defaultProviders.forEach { register($0) }
    }

    /// Registers a provider in the registry
    public func register(_ provider: Provider) {
        providers[provider.type] = provider
    }

    /// Retrieves a provider by its type identifier
    public func provider(for type: String) throws -> Provider {
        guard let provider = providers[type] else {
            throw ProviderError.unknownProvider(type)
        }
        return provider
    }
}
