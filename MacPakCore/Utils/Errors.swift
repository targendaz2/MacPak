//
//  Errors.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 David G Rosenberg. All rights reserved.
//

import Foundation

/// Errors that can occur during validation of inputs.
enum ValidationError: Error, CustomStringConvertible {
    case unknownProvider(String)
    case missingOrInvalidArgument(String)
    
    var description: String {
        switch self {
        case .unknownProvider(let type):
            return "Unknown provider type: \(type)"
        case .missingOrInvalidArgument(let arg):
            return "Missing or invalid argument: \(arg)"
        }
    }
}
