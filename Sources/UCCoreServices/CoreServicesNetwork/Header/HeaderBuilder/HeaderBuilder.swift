//
//  HeaderBuilder.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 03/11/2025.
//

import Foundation

public struct HeaderBuilder: Sendable {
    private let providers: [HeaderProvider]
    
    public init(providers: [HeaderProvider]) {
        self.providers = providers
    }
    
    public func headers() -> [String: String] {
        self.providers.reduce(into: [String: String]()) { acc, provider in
            acc.merge(provider.headers(), uniquingKeysWith: { _, new in new })
        }
    }
}
