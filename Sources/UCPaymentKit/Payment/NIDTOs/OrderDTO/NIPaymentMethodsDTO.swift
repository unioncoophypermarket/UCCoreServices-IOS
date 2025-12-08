//
//  NIPaymentMethodsDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

// Payment methods container
public struct NIPaymentMethodsDTO: Codable {
    public let card: [String]?
    public let wallet: [String]?
    // other categories may appear; keep optional
}
