//
//  HeaderComponent.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 9/18/23.
//

import Foundation

public struct HeaderComponent: Sendable {
    
    // MARK: - Public Properties
    public private(set) var headers: [String: String] = [:]
    
    // MARK: - Init
    public init(components: [Component]) {
        self.headers = Dictionary(uniqueKeysWithValues: components.map { ($0.key, $0.value) })
    }
    
    // MARK: - Public Methods
    public mutating func add(_ component: Component) {
        self.headers[component.key] = component.value
    }
    
    public mutating func merge(_ components: [Component]) {
        components.forEach {
            self.headers[$0.key] = $0.value
        }
    }
}

// MARK: - Component
public extension HeaderComponent {
    
    enum Component {
        // MARK: Authentication
        case authorization(_ value: String)
        case authorizationBearer(_ token: String)
        
        // MARK: Common Headers
        case deviceId(_ value: String)
        case appKey(_ value: String)
        case apiKey(_ value: String)
        case apiPassword(_ value: String)
        case deviceType(_ value: String)
        case language(_ value: String)
        case appVersion(_ value: String)
        case company(_ value: String)
        case sessionId(_ value: String)
        case userId(_ value: String)
        case cityId(_ value: String)
        case areaId(_ value: String)
        case clientId(_ value: String)
        case token(_ value: String)
        
        // MARK: Content Negotiation
        case accept(_ value: Accept)
        case contentType(_ value: ContentType)
        
        // MARK: Custom Header
        case other(_ key: String, _ value: String)
        
        // MARK: - Header Keys
        public var key: String {
            switch self {
            case .authorization, .authorizationBearer: return "Authorization"
            case .deviceId:     return "Device-Id"
            case .appKey:       return "App-Key"
            case .apiKey:       return "Api-Key"
            case .apiPassword:  return "Api-Pwd"
            case .deviceType:   return "Device-Type"
            case .language:     return "Lang"
            case .accept:       return "Accept"
            case .contentType:  return "Content-Type"
            case .sessionId:    return "Session-Id"
            case .userId:       return "User-Id"
            case .cityId:       return "City-Id"
            case .areaId:       return "Area-Id"
            case .token:        return "Token"
            case .clientId:     return "Client-Id"
            case .appVersion:   return "App-Version"
            case .company:      return "Company"
            case let .other(key, _):
                return key
            }
        }
        
        // MARK: - Header Values (all come from outside)
        public var value: String {
            switch self {
            case let .authorization(value),
                let .apiKey(value),
                let .apiPassword(value),
                let .sessionId(value),
                let .cityId(value),
                let .areaId(value),
                let .userId(value),
                let .clientId(value),
                let .token(value),
                let .appKey(value),
                let .deviceId(value),
                let .deviceType(value),
                let .language(value),
                let .appVersion(value),
                let .company(value),
                let .other(_, value):
                return value
                
            case let .authorizationBearer(token):
                return "Bearer \(token)"
                
            case let .accept(acceptValue):
                return acceptValue.rawValue
                
            case let .contentType(contentTypeValue):
                return contentTypeValue.rawValue
            }
        }
    }
    
    // MARK: - Accept
    enum Accept: String {
        /// Expected response format
        case applicationJson = "application/json"
    }
    
    // MARK: - ContentType
    enum ContentType: String {
        /// Request body format
        case applicationJson = "application/json"
    }
}
