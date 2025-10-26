//
//  Errors.swift
//  MacPakCore
//
//  Created by David Rosenberg on 10/25/25.
//  Copyright © 2025 DGR Dev. All rights reserved.
//

import Foundation

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
