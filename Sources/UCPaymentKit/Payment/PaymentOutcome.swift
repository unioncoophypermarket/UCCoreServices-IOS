//
//  PaymentOutcome.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 16/11/2026.
//

import Foundation

/// How a card payment ended, as far as the host can prove it.
///
/// Unlike `PaymentResult`, it keeps a card that was not charged (`failed`) apart from a payment whose outcome the host
/// could not confirm (`unconfirmed`). After 3-D Secure the bank may already have taken the money while the payment
/// SDK stopped without a word, so an unconfirmed payment is never a failure: the module must not start a new charge
/// for it, nor tell its server the card wasn't charged, until `PaymentPresenter.resolvePayment(orderReference:)`
/// settles it.
public enum PaymentOutcome: Equatable, Sendable {
    /// The gateway took the payment. The module's own server still confirms it, as for `PaymentResult.success`.
    case paid(orderReference: String)
    /// The card was not charged: a new attempt is safe.
    case failed(orderReference: String)
    /// The customer closed the card screen before any money moved.
    case cancelled(orderReference: String)
    /// The host could not confirm the outcome: the bank may have taken the money.
    case unconfirmed(orderReference: String)

    /// A host that only reports `PaymentResult` never reports an unconfirmed payment.
    public init(_ result: PaymentResult) {
        switch result {
        case .success(let orderReference):
            self = .paid(orderReference: orderReference)
        case .cancelled(let orderReference):
            self = .cancelled(orderReference: orderReference)
        case .failed(let orderReference):
            self = .failed(orderReference: orderReference)
        }
    }

    public var orderReference: String {
        switch self {
        case .paid(let orderReference),
             .failed(let orderReference),
             .cancelled(let orderReference),
             .unconfirmed(let orderReference):
            return orderReference
        }
    }

    /// The outcome for a caller of the `PaymentResult` API, which has no unconfirmed case: it is reported as failed,
    /// as every unknown outcome was before this type.
    public var legacyResult: PaymentResult {
        switch self {
        case .paid(let orderReference):
            return .success(orderReference: orderReference)
        case .cancelled(let orderReference):
            return .cancelled(orderReference: orderReference)
        case .failed(let orderReference), .unconfirmed(let orderReference):
            return .failed(orderReference: orderReference)
        }
    }
}
