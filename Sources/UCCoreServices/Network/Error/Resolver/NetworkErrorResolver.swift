//
//  NetworkErrorResolver.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 13/04/2026.
//

import Foundation
import UCNetworkKit

public final class NetworkErrorResolver {
    
    // MARK: - Init
    public init() {}
    
    // MARK: - Resolve
    public static func resolve(_ error: Error) -> ResolvedError {
        
        if let dataTransferError = error as? DataTransferError {
            return self.resolve(dataTransferError)
        }
        
        if let networkError = error as? NetworkError {
            return self.resolve(networkError)
        }
        
        if error is DecodingError {
            return self.parsingError()
        }
        
        return self.unknownError(error: error)
    }
}

private extension NetworkErrorResolver {
    
    static func resolve(_ error: DataTransferError) -> ResolvedError {
        switch error {
        case .noResponse:
            return ResolvedError(message: NetworkErrorLocalizableKeys.noServerResponse,
                                 category: .server,
                                 statusCode: nil)
            
        case .parsing(_):
            return ResolvedError(message: NetworkErrorLocalizableKeys.parsingError,
                                 category: .parsing,
                                 statusCode: nil)
            
        case let .networkFailure(networkError):
            return self.resolve(networkError)
            
        case let .resolvedNetworkFailure(error):
            return self.resolve(error)
        }
    }
}

private extension NetworkErrorResolver {
    
    static func resolve(_ error: NetworkError) -> ResolvedError {
        switch error {
            
        case let .error(statusCode, _):
            return self.resolveStatusCode(statusCode)
            
        case .notConnected:
            return ResolvedError(message: NetworkErrorLocalizableKeys.noInternetConnection,
                                 category: .network,
                                 statusCode: error.errorCode)
            
        case .cancelled:
            //Will not show message incase of request cancel
            return ResolvedError(message: nil,
                                 category: .cancelled,
                                 statusCode: error.errorCode)
            
        case .urlGeneration:
            return ResolvedError(message: NetworkErrorLocalizableKeys.invalidURL,
                                 category: .client,
                                 statusCode: error.errorCode)
            
        case .generic:
            return ResolvedError(message: NetworkErrorLocalizableKeys.unexpectedError,
                                 category: .unknown,
                                 statusCode: -1)
        }
    }
}

private extension NetworkErrorResolver {
    
    static func resolveStatusCode(_ code: Int) -> ResolvedError {
        switch code {
        case 401:
            //Will handle by AuthorizationManager
            return ResolvedError(message: nil,
                                 category: .client,
                                 statusCode: code)
            
        case 403:
            return ResolvedError(message: NetworkErrorLocalizableKeys.forbidden,
                                 category: .client,
                                 statusCode: code)
            
        case 404:
            return ResolvedError(message: NetworkErrorLocalizableKeys.notFound,
                                 category: .client,
                                 statusCode: code)
            
        case 500...599:
            return ResolvedError(message: NetworkErrorLocalizableKeys.serverError,
                                 category: .server,
                                 statusCode: code)
            
        default:
            return ResolvedError(message: NetworkErrorLocalizableKeys.unexpectedError,
                                 category: .unknown,
                                 statusCode: code)
        }
    }
}

private extension NetworkErrorResolver {
    
    static func parsingError() -> ResolvedError {
        ResolvedError(message: NetworkErrorLocalizableKeys.parsingError,
                      category: .parsing,
                      statusCode: nil)
    }
    
    static func unknownError(error: Error) -> ResolvedError {
        ResolvedError(message: error.localizedDescription,
                      category: .unknown,
                      statusCode: nil)
    }
}
