//
//  ApplePayError.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 6/19/25.
//

import PassKit

enum ApplePayError: Error, Sendable {
    case presentationFailed
    case authorizationFailed(PKPaymentAuthorizationStatus)
    
    var localizedDescription: String {
        switch self {
        case .presentationFailed:
            return "Failed to present Apple Pay payment controller."
        case .authorizationFailed(let status):
            switch status {
            case .failure:
                return "Payment failed due to an unknown error."
            case .invalidBillingPostalAddress:
                return "The provided billing postal address is invalid."
            case .invalidShippingPostalAddress:
                return "The provided shipping postal address is invalid."
            case .invalidShippingContact:
                return "The provided shipping contact information is invalid."
            case .pinRequired:
                return "A PIN is required to proceed with the payment."
            case .pinIncorrect:
                return "The entered PIN is incorrect."
            case .pinLockout:
                return "Too many incorrect PIN attempts. Try again later."
            case .success:
                return "Payment completed successfully."
            @unknown default:
                return "An unknown Apple Pay error occurred."
            }
        }
    }
}

