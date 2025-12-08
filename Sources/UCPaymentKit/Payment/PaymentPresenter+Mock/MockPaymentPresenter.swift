//
//  MockPaymentPresenter.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 03/12/2025.
//

import Foundation

@MainActor
public final class MockPaymentPresenter: PaymentPresenter {
    
    var resultToReturn: PaymentResult = .success(orderReference: "3223")
    
    public func presentPayment(withType type: PaymentViewType, completion: @escaping (PaymentResult) -> Void) {
        completion(self.resultToReturn)
    }
    
}
