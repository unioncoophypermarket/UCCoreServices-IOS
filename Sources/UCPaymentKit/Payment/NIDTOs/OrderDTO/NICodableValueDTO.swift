//
//  NICodableValueDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

public enum NICodableValueDTO: Codable {
    case string(String)
    case number(Double)
    case object([String: NICodableValueDTO])
    case array([NICodableValueDTO])
    case bool(Bool)
    case null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
            return
        }

        if let s = try? container.decode(String.self) { self = .string(s); return }
        if let n = try? container.decode(Double.self) { self = .number(n); return }
        if let b = try? container.decode(Bool.self) { self = .bool(b); return }
        if let a = try? container.decode([NICodableValueDTO].self) { self = .array(a); return }
        if let o = try? container.decode([String: NICodableValueDTO].self) { self = .object(o); return }

        // fallback
        self = .null
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let s): try container.encode(s)
        case .number(let n): try container.encode(n)
        case .bool(let b): try container.encode(b)
        case .array(let a): try container.encode(a)
        case .object(let o): try container.encode(o)
        case .null: try container.encodeNil()
        }
    }
}

extension NICodableValueDTO {
    /// Decode a keyed dictionary of NICodableValueDTO from a nested decoder
    public static func decodeDictionary(from decoder: Decoder) throws -> [String: NICodableValueDTO] {
        // first try single value
        let container = try decoder.singleValueContainer()
        if let dict = try? container.decode([String: NICodableValueDTO].self) {
            return dict
        }

        // fallback: keyed container iteration
        let keyed = try decoder.container(keyedBy: DynamicCodingKey.self)
        var result: [String: NICodableValueDTO] = [:]
        for key in keyed.allKeys {
            if let value = try? keyed.decode(NICodableValueDTO.self, forKey: key) {
                result[key.stringValue] = value
            }
        }
        return result
    }

    // dynamic coding key used by fallback decode
    public struct DynamicCodingKey: CodingKey {
        public var stringValue: String
        public var intValue: Int? { return nil }
        public init?(stringValue: String) { self.stringValue = stringValue }
        public init?(intValue: Int) { return nil }
    }
}
