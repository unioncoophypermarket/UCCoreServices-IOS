//
//  NIPaymentMethodDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

public struct NIPaymentMethodDTO: Decodable {
    public let expiry: String?
    public let cardType: String?
    public let issuingCountry: String?
    public let cvv: String?
    public let pan: String?
    public let cardCategory: String?
    public let cardholderName: String?
    public let name: String?
    public let issuingOrg: String?
}
