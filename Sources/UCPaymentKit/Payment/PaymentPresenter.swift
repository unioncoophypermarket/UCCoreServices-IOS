//
//  PaymentPresenter.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 03/12/2025.
//

import Foundation

@MainActor
public protocol PaymentPresenter: AnyObject {
    /// Present the card payment the module's server started.
    /// - Parameter type: the gateway order (new card) or payment (saved card) to pay.
    /// - Parameter completion: called once with the result; completion is always called on main actor. A payment
    ///   whose outcome the host could not confirm is reported as `.failed`: use `presentPayment(withType:onOutcome:)`
    ///   to tell the two apart.
    func presentPayment(withType type: PaymentViewType,
                        completion: @escaping (PaymentResult) -> Void)

    /// Present the card payment the module's server started, and report how it ended, keeping a payment that could not
    /// be confirmed apart from one that failed.
    /// - Parameter onOutcome: called once, on the main actor.
    func presentPayment(withType type: PaymentViewType,
                        onOutcome: @escaping (PaymentOutcome) -> Void)

    /// Asks again how a payment that ended `.unconfirmed` really ended, by its order reference. Answers
    /// `.unconfirmed` while the host still can't tell; never starts a new charge.
    func resolvePayment(orderReference: String) async -> PaymentOutcome
}

public extension PaymentPresenter {

    /// A host that only implements the `PaymentResult` API: its result, as an outcome.
    func presentPayment(withType type: PaymentViewType,
                        onOutcome: @escaping (PaymentOutcome) -> Void) {
        self.presentPayment(withType: type) { result in
            onOutcome(PaymentOutcome(result))
        }
    }

    /// A host that can't look a payment up again can't settle it.
    func resolvePayment(orderReference: String) async -> PaymentOutcome {
        .unconfirmed(orderReference: orderReference)
    }
}
