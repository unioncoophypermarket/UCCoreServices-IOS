//
//  ApplePayButtonRepresentable.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 12/08/25.
//

import UIKit
import PassKit
import SwiftUI

public struct ApplePayButtonRepresentable: UIViewRepresentable {
    
    public var onTap: () -> Void
    public var isEnabled: Bool

    public init(onTap: @escaping () -> Void, isEnabled: Bool = true) {
        self.onTap = onTap
        self.isEnabled = isEnabled
    }

    public class Coordinator: NSObject {
        let onTap: () -> Void

        init(onTap: @escaping () -> Void) {
            self.onTap = onTap
        }

        @objc func handleTap() {
            onTap()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }

    public func makeUIView(context: Context) -> PKPaymentButton {
        let button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)

        button.addTarget(context.coordinator,
                         action: #selector(Coordinator.handleTap),
                         for: .touchUpInside)

        button.isAccessibilityElement = true
        button.accessibilityLabel = "Pay with Apple Pay"
        button.isEnabled = isEnabled

        return button
    }

    public func updateUIView(_ uiView: PKPaymentButton, context: Context) {
        uiView.isEnabled = isEnabled
    }
}
