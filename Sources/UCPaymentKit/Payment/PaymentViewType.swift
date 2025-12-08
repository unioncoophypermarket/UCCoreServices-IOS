//
//  PaymentViewType.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 03/12/2025.
//

import Foundation

/// Host receives raw JSON data (module sends encoded JSON).
public enum PaymentViewType {
    case cardPayment(orderDTO: NIOrderDTO)
    case threeDS(paymentDTO: NIPaymentDTO)
}
