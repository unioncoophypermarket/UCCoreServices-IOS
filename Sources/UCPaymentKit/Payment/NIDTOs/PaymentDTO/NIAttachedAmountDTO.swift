//
//  NIAttachedAmountDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

public struct NIAttachedAmountDTO: Codable {
    
    public let currencyCode: String
    public let value: Int // minor units (e.g., 95 -> 0.95)

    // decimal in major units (assumes 100 minor units per major)
    public var decimalValue: Decimal {
        return Decimal(value) / Decimal(100)
    }
}

