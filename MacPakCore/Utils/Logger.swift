//
//  Logger.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/26/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation

public struct Logger {
    public static func info(_ message: String) { print("ℹ️ \(message)") }
    public static func warn(_ message: String) { print("⚠️ \(message)") }
    public static func error(_ message: String) { print("❌ \(message)") }
}
