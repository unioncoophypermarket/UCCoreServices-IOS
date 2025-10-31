//
//  ComponentHeaderProvider.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 03/11/2025.
//


public protocol HeaderProvider: Sendable {
    func headers() -> [String: String]
}

public struct ComponentHeaderProvider: HeaderProvider {
    
    private let components: @Sendable () -> [HeaderComponent.Component]
    
    public init(components: @escaping @Sendable () -> [HeaderComponent.Component]) {
        self.components = components
    }
    
    public func headers() -> [String : String] {
        // Filter out empty values (avoids sending empty Authorization, etc.)
        Dictionary(
            uniqueKeysWithValues: self.components()
                .map {
                    ($0.key, $0.value)
                }
                .filter {
                    !$0.1.isEmpty
                }
        )
    }
}

