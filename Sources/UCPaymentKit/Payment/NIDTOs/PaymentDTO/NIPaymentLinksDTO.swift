//
//  NIPaymentLinksDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

public struct NIPaymentLinksDTO {
    public let paymentLink: String?
    public let cardPaymentLink: String?
    public let savedCardPaymentLink: String?
    public let threeDSTermURL: String?
    public let threeDSTwoAuthenticationURL: String?
    public let threeDSTwoChallengeResponseURL: String?
    public let applePayLink: String?
    public let partialAuthAccept: String?
    public let partialAuthDecline: String?
    public let aaniPaymentLink: String?
}

extension NIPaymentLinksDTO: Decodable {

    // Helper keyed types for nested { "<rel>": { "href": "..." } } decoding
    private struct HrefKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { nil }
        init?(intValue: Int) { nil }
    }

    private struct AnyKey: CodingKey {
        var stringValue: String
        init(_ string: String) { self.stringValue = string }
        init?(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { nil }
        init?(intValue: Int) { nil }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AnyKey.self)

        func read(_ sdkKey: String, flatKey: String) -> String? {
            // 1) nested object { sdkKey: { "href": "..." } }
            if let nested = try? container.nestedContainer(keyedBy: HrefKey.self, forKey: AnyKey(sdkKey)),
               let href = try? nested.decodeIfPresent(String.self, forKey: HrefKey(stringValue: "href")!) {
                return href
            }
            // 2) flat string under flatKey
            if let directFlat = try? container.decodeIfPresent(String.self, forKey: AnyKey(flatKey)) {
                return directFlat
            }
            // 3) flat string under sdkKey (server used SDK key directly)
            if let directSdk = try? container.decodeIfPresent(String.self, forKey: AnyKey(sdkKey)) {
                return directSdk
            }
            // 4) nested under flatKey (rare)
            if let nestedFlat = try? container.nestedContainer(keyedBy: HrefKey.self, forKey: AnyKey(flatKey)),
               let href = try? nestedFlat.decodeIfPresent(String.self, forKey: HrefKey(stringValue: "href")!) {
                return href
            }
            return nil
        }

        paymentLink = read("self", flatKey: "paymentLink")
        cardPaymentLink = read("payment:card", flatKey: "cardPaymentLink")
        savedCardPaymentLink = read("payment:saved-card", flatKey: "savedCardPaymentLink")
        threeDSTermURL = read("cnp:3ds", flatKey: "threeDSTermURL")
        threeDSTwoAuthenticationURL = read("cnp:3ds2-authentication", flatKey: "threeDSTwoAuthenticationURL")
        threeDSTwoChallengeResponseURL = read("cnp:3ds2-challenge-response", flatKey: "threeDSTwoChallengeResponseURL")
        applePayLink = read("payment:apple_pay", flatKey: "applePayLink")
        partialAuthAccept = read("payment:partial-auth-accept", flatKey: "partialAuthAccept")
        partialAuthDecline = read("payment:partial-auth-decline", flatKey: "partialAuthDecline")
        aaniPaymentLink = read("payment:aani", flatKey: "aaniPaymentLink")
    }
}

extension NIPaymentLinksDTO: Encodable {
    public func encode(to encoder: Encoder) throws {
        // We encode only the flattened string properties we hold.
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(paymentLink, forKey: .paymentLink)
        try container.encodeIfPresent(cardPaymentLink, forKey: .cardPaymentLink)
        try container.encodeIfPresent(savedCardPaymentLink, forKey: .savedCardPaymentLink)
        try container.encodeIfPresent(threeDSTermURL, forKey: .threeDSTermURL)
        try container.encodeIfPresent(threeDSTwoAuthenticationURL, forKey: .threeDSTwoAuthenticationURL)
        try container.encodeIfPresent(threeDSTwoChallengeResponseURL, forKey: .threeDSTwoChallengeResponseURL)
        try container.encodeIfPresent(applePayLink, forKey: .applePayLink)
        try container.encodeIfPresent(partialAuthAccept, forKey: .partialAuthAccept)
        try container.encodeIfPresent(partialAuthDecline, forKey: .partialAuthDecline)
        try container.encodeIfPresent(aaniPaymentLink, forKey: .aaniPaymentLink)
    }

    private enum CodingKeys: String, CodingKey {
        case paymentLink
        case cardPaymentLink
        case savedCardPaymentLink
        case threeDSTermURL
        case threeDSTwoAuthenticationURL
        case threeDSTwoChallengeResponseURL
        case applePayLink
        case partialAuthAccept
        case partialAuthDecline
        case aaniPaymentLink
    }
}

