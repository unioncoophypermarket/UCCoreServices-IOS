//
//  DefaultInterceptor.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 8/12/24.
//

import Foundation
import UCNetworkKit

public final class DefaultInterceptor: Intercepting {
    
    public init() {}
    
    public func interceptResponse(_ request: URLRequest, _ response: URLResponse?, _ responseData: Data?) {
//        SlackManager.shared.sendMessage(message: SlackUnSuccessfulRequestResponseMessage(request: request, response: response, responseData: responseData))
    }
    
    public func interceptError(_ request: URLRequest, _ error: any Error) {
//        SlackManager.shared.sendMessage(message: SlackFailureRequestMessage(request: request, error: error))
//        AuthorizationManager.shared.validateUnauthorizedAccess(for: error)
    }
}

