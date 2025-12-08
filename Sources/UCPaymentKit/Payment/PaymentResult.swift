//
//  PaymentResult.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 03/12/2025.
//

import Foundation

public enum PaymentResult {
    case success(orderReference: String)
    case cancelled(orderReference: String)
    case failed(orderReference: String)
}
