//
//  NIPaymentDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

public struct NIPaymentDTO: Decodable {
    public let id: String?               // maps from "_id"
    public let state: String?
    public let mid: String?
    public let orderReference: String?
    public let paymentMethod: NIPaymentMethodDTO?
    public let amount: NIAttachedAmountDTO?
    public let originIp: String?
    public let links: NIPaymentLinksDTO?         // maps from _links or paymentLinks
    public let threeDSTwoConfig: NIDSTwoConfigDTO? // maps from "3ds2"
    public let updateDateTime: String?
    public let outletId: String?
    public let merchantOrderReference: String?
    public let reference: String?
    public let authenticationCode: String?

    // Public initializer to allow construction from other modules
    public init(
        id: String?,
        state: String?,
        mid: String?,
        orderReference: String?,
        paymentMethod: NIPaymentMethodDTO?,
        amount: NIAttachedAmountDTO?,
        originIp: String?,
        links: NIPaymentLinksDTO?,
        threeDSTwoConfig: NIDSTwoConfigDTO?,
        updateDateTime: String?,
        outletId: String?,
        merchantOrderReference: String?,
        reference: String?,
        authenticationCode: String?
    ) {
        self.id = id
        self.state = state
        self.mid = mid
        self.orderReference = orderReference
        self.paymentMethod = paymentMethod
        self.amount = amount
        self.originIp = originIp
        self.links = links
        self.threeDSTwoConfig = threeDSTwoConfig
        self.updateDateTime = updateDateTime
        self.outletId = outletId
        self.merchantOrderReference = merchantOrderReference
        self.reference = reference
        self.authenticationCode = authenticationCode
    }

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case state, mid, orderReference, paymentMethod, amount, originIp
        case links = "_links"
        case threeDSTwoConfig = "3ds2"
        case updateDateTime, outletId, merchantOrderReference, reference, authenticationCode
    }
}
