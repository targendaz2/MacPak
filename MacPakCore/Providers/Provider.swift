//
//  Provider.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation
import SemVer

public protocol Provider {
    static var type: String { get }
    static var version: Version { get }

    func materialize(from declaration: ComponentDeclaration, context: BuildContext) throws
        -> MaterializedComponent
}
