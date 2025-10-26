//
//  ProviderRegistry.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation

public final class ProviderRegistry {
    public static let shared = ProviderRegistry()

    public var providers: [String: Provider] = [:]

    private init() {}

    public func register(_ provider: Provider) {
        providers[type(of: provider).type] = provider
    }

    public func provider(for type: String) -> Provider? {
        return providers[type]
    }
}
