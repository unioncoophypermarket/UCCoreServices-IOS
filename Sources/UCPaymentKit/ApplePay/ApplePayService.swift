//
//  ApplePayService.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 6/19/25.
//

import Foundation
import PassKit
#if os(macOS)
import AppKit
#endif

public typealias ApplePayCompletion = @Sendable (Result<String, ApplePayError>) -> Void

@MainActor
public final class ApplePayService: NSObject {
    
    // MARK: - Singleton
    public static let shared = ApplePayService()
    private override init() {}
    
    // MARK: - Properties
    private var completion: ApplePayCompletion?
    private var resultStatus: PKPaymentAuthorizationStatus = .failure
    private var tokenBlob: String?
    private var paymentController: PKPaymentAuthorizationController?
    
    // MARK: - Start Payment
    /// Start Apple Pay with the provided request. Completion returns either:
    /// - a JSON string (e.g. "{\"data\":\"...\",\"signature\":\"...\"...}") when possible, or
    /// - a Base64 string fallback.
    public func start(with request: PKPaymentRequest, completion: @escaping ApplePayCompletion) {
        self.completion = completion
        self.resultStatus = .failure
        self.tokenBlob = nil
        
        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        controller.delegate = self
        self.paymentController = controller
        
        // Keep local copy to satisfy @Sendable capture rules.
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
    
    // MARK: - Helpers
    /// Try to produce a JSON string from the raw token data. If that fails, return Base64.
    private func tokenJSONString(from data: Data) -> String {
        // 1) If data is valid UTF-8 text and looks like JSON, return it.
        if let asText = String(data: data, encoding: .utf8),
           asText.first == "{",
           asText.contains("\"data\"") {
            return asText
        }
        
        // 2) Try deserialize and re-serialize to canonical JSON string.
        if let object = try? JSONSerialization.jsonObject(with: data, options: []),
           JSONSerialization.isValidJSONObject(object),
           let canonical = try? JSONSerialization.data(withJSONObject: object, options: []),
           let canonicalString = String(data: canonical, encoding: .utf8) {
            return canonicalString
        }
        
        // 3) Fallback: base64-encoded string (safe when JSON text not available).
        return data.base64EncodedString()
    }
}

// MARK: - PKPaymentAuthorizationControllerDelegate
extension ApplePayService: @MainActor PKPaymentAuthorizationControllerDelegate {
    
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController,
                                               didAuthorizePayment payment: PKPayment,
                                               handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        self.resultStatus = .success
        
        // Use the helper to prefer JSON text; fallback to Base64 automatically.
        self.tokenBlob = tokenJSONString(from: payment.token.paymentData)
        
        completion(.init(status: .success, errors: []))
    }
    
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        // Capture values to avoid capturing self in closure while controller.dismiss executes.
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
    public func presentationWindow(for controller: PKPaymentAuthorizationController) -> UIWindow? {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.windows.first { $0.isKeyWindow } ?? scene?.windows.first
    }
    #endif
    
    #if os(macOS)
    @available(macOS 11.0, *)
    public func presentationWindow(for controller: PKPaymentAuthorizationController) -> NSWindow? {
        return NSApp.keyWindow ?? NSApp.windows.first
    }
    #endif
}
