//
// NIOrderDTO.swift
// UCPaymentKit
//
// Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

// MARK: - The main order DTO (maps to "order_response")
public struct NIOrderDTO: Codable {
    
    public let formattedOrderSummary: [String: NICodableValueDTO]? // generic placeholder
    public let language: String?
    public let amount: NIAttachedAmountDTO?
    public let reference: String?
    public let isSplitPayment: Bool?
    public let merchantDetails: NIMerchantDetailsDTO?
    public let paymentMethods: NIPaymentMethodsDTO?
    public let merchantOrderReference: String?
    public let merchantDefinedData: [String]?
    public let id: String?              // maps from "_id"
    public let action: String?
    public let embedded: NIEmbeddedDTO? // maps from "_embedded"
    public let outletId: String?
    public let isSaudiPaymentEnabled: Bool?
    public let type: String?
    public let merchantAttributes: [String: NICodableValueDTO]?
    public let payoutDetails: NIPayoutDetailsDTO?
    public let referrer: String?
    public let createDateTime: Date?
    public let links: NIOrderLinksDTO?
    public let isSamsungPayV2: Bool?
    public let formattedAmount: String?
    public let formattedOriginalAmount: String?
    
    private enum CodingKeys: String, CodingKey {
        case formattedOrderSummary, language, amount, reference, isSplitPayment, merchantDetails, paymentMethods, merchantOrderReference, merchantDefinedData
        case id = "_id"
        case action
        case embedded = "_embedded"
        case outletId, isSaudiPaymentEnabled, type, merchantAttributes, payoutDetails, referrer, createDateTime
        case links = "_links"
        case isSamsungPayV2, formattedAmount, formattedOriginalAmount
    }
    
    // Custom decode to parse createDateTime into Date?
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.formattedOrderSummary = try container.decodeIfPresent([String: NICodableValueDTO].self, forKey: .formattedOrderSummary)
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        self.amount = try container.decodeIfPresent(NIAttachedAmountDTO.self, forKey: .amount)
        self.reference = try container.decodeIfPresent(String.self, forKey: .reference)
        self.isSplitPayment = try container.decodeIfPresent(Bool.self, forKey: .isSplitPayment)
        self.merchantDetails = try container.decodeIfPresent(NIMerchantDetailsDTO.self, forKey: .merchantDetails)
        self.paymentMethods = try container.decodeIfPresent(NIPaymentMethodsDTO.self, forKey: .paymentMethods)
        self.merchantOrderReference = try container.decodeIfPresent(String.self, forKey: .merchantOrderReference)
        self.merchantDefinedData = try container.decodeIfPresent([String].self, forKey: .merchantDefinedData)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.action = try container.decodeIfPresent(String.self, forKey: .action)
        self.embedded = try container.decodeIfPresent(NIEmbeddedDTO.self, forKey: .embedded)
        self.outletId = try container.decodeIfPresent(String.self, forKey: .outletId)
        self.isSaudiPaymentEnabled = try container.decodeIfPresent(Bool.self, forKey: .isSaudiPaymentEnabled)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.merchantAttributes = try container.decodeIfPresent([String: NICodableValueDTO].self, forKey: .merchantAttributes)
        self.payoutDetails = try container.decodeIfPresent(NIPayoutDetailsDTO.self, forKey: .payoutDetails)
        self.referrer = try container.decodeIfPresent(String.self, forKey: .referrer)
        self.formattedAmount = try container.decodeIfPresent(String.self, forKey: .formattedAmount)
        self.formattedOriginalAmount = try container.decodeIfPresent(String.self, forKey: .formattedOriginalAmount)
        self.isSamsungPayV2 = try container.decodeIfPresent(Bool.self, forKey: .isSamsungPayV2)
        
        // createDateTime (string -> Date?)
        if let dtString = try container.decodeIfPresent(String.self, forKey: .createDateTime) {
            self.createDateTime = NIOrderDTO.iso8601Date(from: dtString)
        } else {
            self.createDateTime = nil
        }
        
        // _links decoding via NIOrderLinksDTO which is defensive and handles both string and object hrefs
        self.links = try container.decodeIfPresent(NIOrderLinksDTO.self, forKey: .links)
    }
    
    // simple encode uses synthesized encoder by leaving default implementation out.
    // MARK: - Helpers
    private static func iso8601Date(from string: String) -> Date? {
        let iSO8601DateFormatter = ISO8601DateFormatter()
        iSO8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iSO8601DateFormatter.date(from: string) {
            return date
        }
        let f2 = ISO8601DateFormatter()
        f2.formatOptions = [.withInternetDateTime]
        if let d = f2.date(from: string) { return d }
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return df.date(from: string)
    }
    
    /// Convenience decimal value for the order amount in major units.
    public var decimalAmount: Decimal? {
        return amount?.decimalValue
    }
}
