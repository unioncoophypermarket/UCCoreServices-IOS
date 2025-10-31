//
//  Array+prettyPrint.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 31/10/2025.
//


import Foundation

@inline(__always)
private func prettyJSONString(from object: Any) -> String? {
    guard JSONSerialization.isValidJSONObject(object) else { return nil }
    guard let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]) else { return nil }
    return String(data: data, encoding: .utf8)
}

extension Array {
    
    func prettyPrint() -> String {
        // Try JSON first (only valid if elements are JSON types)
        if let json = prettyJSONString(from: self) {
            return json
        }
        // Fallback: line-by-line String(describing:)
        if isEmpty { return "[]" }
        let body = self.map { "  \(String(describing: $0))" }.joined(separator: ",\n")
        return "[\n\(body)\n]"
    }
}
