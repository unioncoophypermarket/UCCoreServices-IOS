//
//  ResolvedError.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 13/04/2026.
//

import Foundation

public struct ResolvedError {
    
    public let message: String?
    public let category: Category
    public let statusCode: Int?

    public enum Category {
        case network
        case server
        case client
        case parsing
        case cancelled
        case unknown
    }
    
}
