//
//  Provider.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation
import SemVer

/// Defines a provider capable of materializing components.
public protocol Provider {
    /// The unique type identifier for this provider.
    static var type: String { get }
    
    /// The version of this provider.
    static var version: Version { get }
    
    /// A brief description of this provider.
    static var description: String { get }

    /// Materializes a component from its declaration within the given build context.
    func materialize(from declaration: ComponentDeclaration, context: BuildContext) throws
        -> MaterializedComponent
}
