//
//  DefaultTransferService.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 31/10/2025.
//

import Foundation
import UCNetworkKit

final public class DefaultTransferService: TransferService {
    
    // MARK: - Private Properties
    private let baseURL: URL
    private let headerBuilder: HeaderBuilder
    private let logger: NetworkLogger?
    private let interceptor: Intercepting?
    
    // MARK: - Init
    public init(baseURL: URL,
                headerProviders: [HeaderProvider],
                logger: NetworkLogger?,
                interceptor: Intercepting?) {
        self.baseURL = baseURL
        self.headerBuilder = HeaderBuilder(providers: headerProviders)
        self.logger = logger
        self.interceptor = interceptor
    }
    
    // MARK: - TransferService
    public func service() -> DataTransferService {
        
        // Build headers dynamically at call time
        let headers = self.headerBuilder.headers()
        
        // Create API configuration with actual headers
        let config = DefaultAPIConfiguration(baseURL: self.baseURL,
                                             headers: headers)
        
        // Create the network service
        let network = DefaultNetworkService(config: config,
                                            logger: self.logger,
                                            interceptor: self.interceptor)
        
        // Return a ready-to-use data transfer service
        return DefaultDataTransferService(with: network, logger: self.logger)
    }
}
