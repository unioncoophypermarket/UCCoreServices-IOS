//
// NIOrderLinksDTO.swift
// UCPaymentKit
//
//

import Foundation

public struct NIOrderLinksDTO: Codable {
    
    public let paymentHref: String?
    public let applePayHref: String?
    public let cardHref: String?
    public let savedCardHref: String?
    public let selfHref: String?
    public let cnpApplePayValidateSessionHref: String?
    public let configGooglePayHref: String?
    public let paymentGooglePayHref: String?
    public let paymentSamsungPayHref: String?
    public let other: [String: String]?

    fileprivate static func extractHref(from value: NICodableValueDTO) -> String? {
        switch value {
        case .string(let s): return s
        case .object(let dict):
            if case .string(let href)? = dict["href"] { return href }
            if case .string(let href)? = dict["url"] { return href }
            return nil
        default:
            return nil
        }
    }

    public init(from decoder: Decoder) throws {
        // Decode raw dictionary into [String: NICodableValueDTO]
        let container = try decoder.singleValueContainer()
        var raw: [String: NICodableValueDTO] = [:]
        if let decoded = try? container.decode([String: NICodableValueDTO].self) {
            raw = decoded
        } else {
            let keyed = try decoder.container(keyedBy: NICodableValueDTO.DynamicCodingKey.self)
            var tmp: [String: NICodableValueDTO] = [:]
            for key in keyed.allKeys {
                if let v = try? keyed.decode(NICodableValueDTO.self, forKey: key) {
                    tmp[key.stringValue] = v
                }
            }
            raw = tmp
        }

        var otherMap: [String: String] = [:]

        func valueFor(_ keys: [String]) -> String? {
            for k in keys {
                if let v = raw[k], let href = NIOrderLinksDTO.extractHref(from: v) { return href }
            }
            return nil
        }

        let paymentHref = valueFor(["payment", "paymentLink", "payment-link", "cnp:payment-link"])
        let applePayHref = valueFor(["payment:apple_pay", "payment:applePay", "applePayLink", "payment:apple_pay"])
        let cardHref = valueFor(["payment:card", "cardPaymentLink"])
        let savedCardHref = valueFor(["payment:saved-card", "savedCardPaymentLink"])
        let selfHref = valueFor(["self", "selfHref"])
        let cnpApplePayValidateSessionHref = valueFor(["cnp:apple_pay_web_validate_session", "cnp:apple_pay_web_validate_session"])
        let configGooglePayHref = valueFor(["config:google_pay", "configGooglePay"])
        let paymentGooglePayHref = valueFor(["payment:google_pay", "payment:google_pay", "paymentGooglePay"])
        let paymentSamsungPayHref = valueFor(["payment:samsung_pay", "payment:samsung_pay", "paymentSamsungPay"])

        for (k, v) in raw {
            if let href = NIOrderLinksDTO.extractHref(from: v) {
                if href == paymentHref || href == applePayHref || href == cardHref || href == savedCardHref || href == selfHref || href == cnpApplePayValidateSessionHref || href == configGooglePayHref || href == paymentGooglePayHref || href == paymentSamsungPayHref {
                    continue
                }
                otherMap[k] = href
            }
        }

        self.paymentHref = paymentHref
        self.applePayHref = applePayHref
        self.cardHref = cardHref
        self.savedCardHref = savedCardHref
        self.selfHref = selfHref
        self.cnpApplePayValidateSessionHref = cnpApplePayValidateSessionHref
        self.configGooglePayHref = configGooglePayHref
        self.paymentGooglePayHref = paymentGooglePayHref
        self.paymentSamsungPayHref = paymentSamsungPayHref
        self.other = otherMap.isEmpty ? nil : otherMap
    }

    public func encode(to encoder: Encoder) throws {
        var dict: [String: String] = [:]
        dict["payment"] = paymentHref
        dict["payment:apple_pay"] = applePayHref
        dict["payment:card"] = cardHref
        dict["payment:saved-card"] = savedCardHref
        dict["self"] = selfHref
        dict["cnp:apple_pay_web_validate_session"] = cnpApplePayValidateSessionHref
        dict["config:google_pay"] = configGooglePayHref
        dict["payment:google_pay"] = paymentGooglePayHref
        dict["payment:samsung_pay"] = paymentSamsungPayHref
        if let other = other {
            for (k, v) in other { dict[k] = v }
        }
        try dict.encode(to: encoder)
    }
}
