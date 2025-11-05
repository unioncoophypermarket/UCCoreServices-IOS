//
//  NetworkError.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 6/18/25.
//

import Foundation

public
enum APIError: Error, LocalizedError {
    
    case statusCodeError(statusCode: String? = nil, message: String? = nil)
    case serverError(error: Error)
    
    public var errorDescription: String? {
        switch self {
        case .statusCodeError(_, let message):
            return message ?? "An unknown error occurred."
        case .serverError(let error):
            return error.localizedDescription
        }
    }
}
