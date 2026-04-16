//
//  Date+Formatting.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 16/04/2026.
//

import Foundation

public extension Date {

    func formatted(
        _ format: DateFormat,
        timeZone: TimeZone? = .gmt
    ) -> String {
        DateFormatterManager.shared.toString(
            self,
            format: format,
            timeZone: timeZone
        )
    }
}
