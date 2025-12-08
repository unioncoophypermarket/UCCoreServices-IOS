//
// NIEmbeddedPaymentDTO.swift
// UCPaymentKit
//
//

import Foundation

public struct NIEmbeddedPaymentDTO: Codable {
    public let id: String?                           // maps from "_id"
    public let links: NIPaymentLinksDTO?             // parsed convenience links (href/nested & flat extraction)
    public let rawLinks: [String: NICodableValueDTO]? // original _links dictionary (if present) - useful for mapping/debug
    public let reference: String?
    public let amount: NIAttachedAmountDTO?
    public let updateDateTime: Date?
    public let merchantOrderReference: String?
    public let orderReference: String?
    public let state: String?
    public let outletId: String?

    private enum CodingKeys: String, CodingKey {
        case links = "_links"
        case reference, amount, updateDateTime, merchantOrderReference, orderReference, state, outletId
        case id = "_id"
    }

    // MARK: - custom decode
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.reference = try container.decodeIfPresent(String.self, forKey: .reference)
        self.amount = try container.decodeIfPresent(NIAttachedAmountDTO.self, forKey: .amount)
        self.merchantOrderReference = try container.decodeIfPresent(String.self, forKey: .merchantOrderReference)
        self.orderReference = try container.decodeIfPresent(String.self, forKey: .orderReference)
        self.state = try container.decodeIfPresent(String.self, forKey: .state)
        self.outletId = try container.decodeIfPresent(String.self, forKey: .outletId)

        if container.contains(.updateDateTime) {
            // Try as string first
            if let dateString = try? container.decodeIfPresent(String.self, forKey: .updateDateTime) {
                self.updateDateTime = NIEmbeddedPaymentDTO.iso8601Date(from: dateString)
            } else if let epochDouble = try? container.decodeIfPresent(Double.self, forKey: .updateDateTime) {
                // epoch seconds (may contain fractional part)
                self.updateDateTime = Date(timeIntervalSince1970: epochDouble)
            } else if let epochInt = try? container.decodeIfPresent(Int.self, forKey: .updateDateTime) {
                self.updateDateTime = Date(timeIntervalSince1970: TimeInterval(epochInt))
            } else {
                self.updateDateTime = nil
            }
        } else {
            self.updateDateTime = nil
        }

        // _links: save raw and also decode convenience links DTO
        if container.contains(.links) {
            let superDecoder = try container.superDecoder(forKey: .links)
            if let decodedRaw = try? NICodableValueDTO.decodeDictionary(from: superDecoder) {
                rawLinks = decodedRaw
            } else {
                rawLinks = nil
            }

            // For convenience decode typed small links DTO (handles string OR object)
            // We attempt to decode using the typed NIPaymentLinksDTO which itself is defensive.
            // If typed decode fails, links will be nil (we still keep rawLinks).
            let linksContainer = try? container.nestedContainer(keyedBy: NICodableValueDTO.DynamicCodingKey.self, forKey: .links)
            if linksContainer != nil {
                links = try? NIPaymentLinksDTO(from: superDecoder)
            } else {
                links = nil
            }
        } else {
            rawLinks = nil
            links = nil
        }
    }

    // Custom encode skipping rawLinks (since rawLinks is heavy for logs)
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(links, forKey: .links)
        try container.encodeIfPresent(reference, forKey: .reference)
        try container.encodeIfPresent(amount, forKey: .amount)
        if let dt = updateDateTime {
            let s = NIEmbeddedPaymentDTO.iso8601String(from: dt)
            try container.encode(s, forKey: .updateDateTime)
        }
        try container.encodeIfPresent(merchantOrderReference, forKey: .merchantOrderReference)
        try container.encodeIfPresent(orderReference, forKey: .orderReference)
        try container.encodeIfPresent(state, forKey: .state)
        try container.encodeIfPresent(outletId, forKey: .outletId)
    }

    // MARK: - Helpers

    /// Convert API date string into Date using ISO8601 tolerant parsing.
    private static func iso8601Date(from string: String) -> Date? {
        // Common ISO8601 formats with fractional seconds first
        let f1 = ISO8601DateFormatter()
        f1.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let d = f1.date(from: string) { return d }

        // Without fractional seconds
        let f2 = ISO8601DateFormatter()
        f2.formatOptions = [.withInternetDateTime]
        if let d = f2.date(from: string) { return d }

        // Some APIs may return timezone-less fractional strings — fallback with POSIX formatter
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        let candidates = [
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        ]
        for pattern in candidates {
            df.dateFormat = pattern
            if let d = df.date(from: string) { return d }
        }
        return nil
    }

    private static func iso8601String(from date: Date) -> String {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f.string(from: date)
    }

    // Computed convenience: decimal amount in major units (AED e.g. fils -> dirham)
    public var decimalAmount: Decimal? {
        guard let a = amount else { return nil }
        return a.decimalValue
    }
}
