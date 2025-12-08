//
//  PaymentPresenter.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 03/12/2025.
//

import Foundation

@MainActor
public protocol PaymentPresenter: AnyObject {
    /// Present a payment flow described by raw JSON data.
    /// - Parameter type: PaymentViewType carrying raw JSON bytes.
    /// - Parameter completion: called once with the result; completion is always called on main actor.
    func presentPayment(withType type: PaymentViewType,
                        completion: @escaping (PaymentResult) -> Void)
}

