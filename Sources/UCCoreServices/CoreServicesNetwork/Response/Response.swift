//
//  Response.swift
//  App
//
//  Created by Mahmoud Alaa on 9/18/23.
//

import Foundation

@frozen
public struct Response<T: Decodable>: Decodable {
    
    public var result: Int?
    public var data: T?
    public var message: String?
    public var code: String?
    
    public enum CodingKeys: String, CodingKey {
        case result, data, code
        case message = "msg"
        
        case uppercaseResult = "Result"
        case uppercaseData = "Data"
        case uppercaseMessage = "Msg"
        case alternateMessage = "message"
        case uppercaseCode = "Code"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.result = try Self.decodeFirst(of: [.result, .uppercaseResult], as: Int.self, from: container)
        self.code = try Self.decodeCode(from: container)
        self.message = try Self.decodeFirst(of: [.message, .alternateMessage, .uppercaseMessage], as: String.self, from: container)
        self.data = Self.decodeSafely(T.self, for: [.data, .uppercaseData], from: container)
    }
}

public
extension Response {
    init(
        result: Int? = 1,
        data: T?,
        message: String? = nil,
        code: String? = "200"
    ) {
        self.result = result
        self.data = data
        self.message = message
        self.code = code
    }
}

// MARK: - Internal Decoding Utilities
private
extension Response {
    
    static func decodeFirst<Value: Decodable>(
        of keys: [CodingKeys],
        as type: Value.Type,
        from container: KeyedDecodingContainer<CodingKeys>
    ) throws -> Value? {
        for key in keys {
            if let value = try? container.decodeIfPresent(Value.self, forKey: key) {
                return value
            }
        }
        return nil
    }
    
    static func decodeCode(from container: KeyedDecodingContainer<CodingKeys>) throws -> String? {
        if let codeStr = try? decodeFirst(of: [.code, .uppercaseCode], as: String.self, from: container) {
            return codeStr
        } else if let codeInt = try? decodeFirst(of: [.code, .uppercaseCode], as: Int.self, from: container) {
            return String(codeInt)
        }
        return nil
    }
    
    static func decodeSafely<Value: Decodable>(
        _ type: Value.Type,
        for keys: [CodingKeys],
        from container: KeyedDecodingContainer<CodingKeys>
    ) -> Value? {
        for key in keys {
            if let value = try? container.decodeIfPresent(Value.self, forKey: key) {
                return value
            }
        }
        return nil
    }
}
