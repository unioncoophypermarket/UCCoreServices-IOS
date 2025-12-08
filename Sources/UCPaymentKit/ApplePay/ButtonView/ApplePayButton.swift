//
//  ApplePayButton.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 12/08/25.
//

import SwiftUI

public struct ApplePayButton: View {
    
    public var onTap: () -> Void
    
    @Binding public var isLoading: Bool
    public var isEnabled: Bool = true
    
    public init(isLoading: Binding<Bool>, isEnabled: Bool = true, onTap: @escaping () -> Void) {
        self._isLoading = isLoading
        self.isEnabled = isEnabled
        self.onTap = onTap
    }
    
    public var body: some View {
        Group {
            if self.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                    .background(Color.black)
                    .cornerRadius(10)
                    .accessibilityLabel("Processing payment")
                    .accessibilityAddTraits(.isButton)
            } else {
                ApplePayButtonRepresentable(onTap: self.onTap, isEnabled: self.isEnabled)
                    .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                    .accessibilityLabel("Pay with Apple Pay")
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}
