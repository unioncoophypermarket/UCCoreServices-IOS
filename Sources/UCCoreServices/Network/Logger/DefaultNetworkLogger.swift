//
//  DefaultNetworkLogger.swift
//  CoreServices
//
//  Created by Mahmoud Alaa on 9/10/23.
//

import Foundation
import OSLog
import UCNetworkKit

public final class DefaultNetworkLogger: NetworkLogger {
    
    public init() { }
    
    // MARK: - Request
    public func log(request: URLRequest) {
        
        let method = request.httpMethod ?? "UNKNOWN"
        let urlString = request.url?.absoluteString ?? "NO-URL"
        let headers = request.allHTTPHeaderFields?.prettyPrint() ?? "No Headers"
        let bodyDescription = describeBody(data: request.httpBody) ?? "No body"
        
        let requestMessage = """
                    ===================== 🛫🛫🛫🛫🛫 =========================
                    🛺💨 \(method) '\(urlString)':
                    🛡️ Request headers = \(headers)
                    🍼 Request Body = \(bodyDescription)
                    """
        self.emit(requestMessage, fault: false)
    }
}

// MARK: - Response
public extension DefaultNetworkLogger {
    
    func log(responseData data: Data?, response: URLResponse?) {
        
        let statusCode: Int = (response as? HTTPURLResponse)?.statusCode ?? 0
        let urlString: String = response?.url?.absoluteString ?? ""
        let headers: String = ((response as? HTTPURLResponse)?.allHeaderFields as? [String: Any])?.prettyPrint() ?? "No Headers 😥"
        let responseBody: String = describeBody(data: data) ?? "No Response 😛"
        
        let responseMessage = """
                    ===================== 🛬🛬🛬🛬🛬 =========================
                    🚦 \(statusCode) '\(urlString)':
                    🛡️ Response headers = \(headers)
                    🎣 Response Body = \(responseBody)
                    
                    """
        self.emit(responseMessage, fault: false)
    }
}

// MARK: - Error
public extension DefaultNetworkLogger {
    
    func log(error: Error) {
        
        let errorMessage: String
        
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .typeMismatch(let expectedType, let context):
                let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                errorMessage = """
                           ===================== 🚨🚨🚨🚨🚨 =========================
                           ❌ Error: Type Mismatch, \(context.debugDescription)
                           🪛 Expected Type: \(expectedType)
                           🚧 Coding Path: \(codingPath)
                           """
            case .valueNotFound(let expectedType, let context):
                let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                errorMessage = """
                           ===================== 🚨🚨🚨🚨🚨 =========================
                           ❌ Error: Value Not Found, \(context.debugDescription)
                           🪛 Expected Type: \(expectedType)
                           🚧 Coding Path: \(codingPath)
                           """
            case .keyNotFound(let key, let context):
                let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                errorMessage = """
                           ===================== 🚨🚨🚨🚨🚨 =========================
                           ❌ Error: Key Not Found, \(context.debugDescription)
                           🗝️ Missing Key: \(key.stringValue)
                           🚧 Coding Path: \(codingPath)
                           """
            case .dataCorrupted(let context):
                let codingPath = context.codingPath.map { $0.stringValue }.joined(separator: " -> ")
                errorMessage = """
                           ===================== 🚨🚨🚨🚨🚨 =========================
                           ❌ Error: Data Corrupted, \(context.debugDescription)
                           🚧 Coding Path: \(codingPath)
                           """
            @unknown default:
                errorMessage = "🚨 DecodingError: \(decodingError)"
            }
        } else {
            errorMessage = "🚨 Error: \(error)"
        }
        
        self.emit(errorMessage, fault: true)
    }
}

// MARK: - Helpers
private extension DefaultNetworkLogger {
    
    /// Attempts to pretty-print JSON bodies; falls back to UTF-8 text; otherwise nil.
    func describeBody(data: Data?) -> String? {
        guard let data, !data.isEmpty else { return nil }
        
        // Try JSON object (dict or array)
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dict = json as? [String: Any] {
                return dict.prettyPrint()
            }
            if let array = json as? [Any] {
                return array.prettyPrint()
            }
        }
        // Try plain text
        if let text = String(data: data, encoding: .utf8) {
            return text
        }
        
        // Fallback to size
        return "Binary Data (\(data.count) bytes)"
    }
    
    func emit(_ message: String, fault: Bool) {
        if fault {
            Logger().fault("\(message)")
        } else {
            Logger().notice("\(message)")
        }
    }
}

