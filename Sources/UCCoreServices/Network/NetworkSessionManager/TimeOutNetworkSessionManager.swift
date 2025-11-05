//
//  TimeOutNetworkSessionManager.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 9/30/25.
//

import Foundation
import UCNetworkKit

public
final class TimeOutNetworkSessionManager: NetworkSessionManager {
    
    private let configuration: URLSessionConfiguration
    private let sessionDelegate: URLSessionDelegate
    
    public
    init(timeout: TimeInterval,
         sessionDelegate: URLSessionDelegate = DefaultSessionDelegate()) {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout
        
        self.configuration = configuration
        self.sessionDelegate = sessionDelegate
    }
    
    public
    func request(_ request: URLRequest) async throws -> NetworkSessionManager.Result {
        let session = URLSession(configuration: configuration,
                                 delegate: sessionDelegate,
                                 delegateQueue: nil)
        
        return try await session.data(for: request)
    }
}
