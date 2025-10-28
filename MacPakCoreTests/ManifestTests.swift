//
//  ManifestTests.swift
//  MacPakCoreTests
//
//  Created by David Rosenberg on 10/26/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation
import SemVer
import Testing

@testable import MacPakCore

struct ManifestTests {

    @Test func testCanDecodeManifest() async throws {
        let plist = """
            <plist version="1.0">
            <dict>
                <key>package</key>
                <dict>
                    <key>name</key>
                    <string>VS Code</string>
                    <key>version</key>
                    <string>1.0.0</string>
                    <key>identifier</key>
                    <string>com.example.vscode</string>
                </dict>
                <key>components</key>
                <array>
                    <dict>
                        <key>name</key>
                        <string>VS Code</string>
                        <key>providerType</key>
                        <string>appBundle</string>
                        <key>arguments</key>
                        <dict>
                            <key>source</key>
                            <string>https://example.com</string>
                        </dict>
                    </dict>
                </array>
            </dict>
            </plist>
            """

        let data = plist.data(using: .utf8)!
        let decoder = PropertyListDecoder()
        decoder.semverVersionDecodingStrategy = .string
        let manifest = try decoder.decode(Manifest.self, from: data)
        #expect(manifest.components.first?.name == "VS Code")
    }

}
