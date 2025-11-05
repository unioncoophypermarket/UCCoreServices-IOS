//
//  ApplePayService.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 6/19/25.
//

import PassKit
#if os(macOS)
import AppKit
#endif

typealias ApplePayCompletion = @Sendable (Result<String, ApplePayError>) -> Void

@MainActor
final class ApplePayService: NSObject {
    
    // MARK: - Singleton
    static let shared = ApplePayService()
    private override init() {}
    
    // MARK: - Properties
    private var completion: ApplePayCompletion?
    private var resultStatus: PKPaymentAuthorizationStatus = .failure
    private var tokenBlob: String?
    private var paymentController: PKPaymentAuthorizationController?
    
    // MARK: - Start Payment
    func start(with request: PKPaymentRequest, completion: @escaping ApplePayCompletion) {
        self.completion = completion
        self.resultStatus = .failure
        self.tokenBlob = nil
        
        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = self
        self.paymentController = controller
        
        // Capture a local, immutable copy to satisfy @Sendable capture requirements
        let completionCopy = completion
        
        controller.present { presented in
            if presented {
                #if DEBUG
                print("✅ [ApplePayService] Apple Pay presented successfully")
                #endif
            } else {
                #if DEBUG
                print("❌ [ApplePayService] Apple Pay presentation failed")
                #endif
                completionCopy(.failure(.presentationFailed))
            }
        }
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePayService: @MainActor PKPaymentAuthorizationControllerDelegate {
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                        didAuthorizePayment payment: PKPayment,
                                        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.resultStatus = .success
        // Prefer Base64 to avoid nil when the token data isn't UTF-8
        self.tokenBlob = payment.token.paymentData.base64EncodedString()
        completion(.init(status: .success, errors: []))
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        // Capture values to avoid capturing self in the completion closure
        let resultStatus = self.resultStatus
        let tokenBlob = self.tokenBlob
        let completionHandler = self.completion
        
        controller.dismiss { [resultStatus, tokenBlob, completionHandler] in
            Task { @MainActor in
                if resultStatus == .success, let token = tokenBlob {
                    completionHandler?(.success(token))
                } else {
                    completionHandler?(.failure(.authorizationFailed(resultStatus)))
                }
                // Clean up for next use
                self.completion = nil
                self.paymentController = nil
                self.resultStatus = .failure
                self.tokenBlob = nil
            }
        }
    }
    
    // MARK: - Presentation Window (required on some platforms)
    #if canImport(UIKit)
    // iOS & Mac Catalyst
    @available(iOS 13.0, *)
    func presentationWindow(for controller: PKPaymentAuthorizationController) -> UIWindow? {
        // Choose the key window / foreground active window
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.windows.first { $0.isKeyWindow } ?? scene?.windows.first
    }
    #endif
    
    #if os(macOS)
    @available(macOS 11.0, *)
    func presentationWindow(for controller: PKPaymentAuthorizationController) -> NSWindow? {
        // Provide the key window on macOS
        return NSApp.keyWindow ?? NSApp.windows.first
    }
    #endif
}
