//
//  AppBundleProvider.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 DGR Dev. All rights reserved.
//

import Foundation
import SemVer

public struct AppBundleProvider: Provider {
    public static let type = "appBundle"
    public static let version = Version("0.1.0")!

    public func materialize(from declaration: ComponentDeclaration, context: BuildContext) throws
        -> MaterializedComponent
    {
        // TODO: implement app bundle staging logic
        return DummyComponent(name: declaration.name, stagingPath: context.stagingDirectory)
    }
}

public struct DummyComponent: MaterializedComponent {
    public let name: String
    public let stagingPath: URL

    public func validate() throws { /* TODO */  }
    public func contribute(to builder: PackageBuilder) throws { /* TODO */  }
}
