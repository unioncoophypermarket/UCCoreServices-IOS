//
//  DateFormatterManager.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 16/04/2026.
//

import Foundation

// MARK: - DateFormatterManager

public final class DateFormatterManager: @unchecked Sendable {

    // MARK: Singleton
    public static let shared = DateFormatterManager()
    
    private init() {}

    // MARK: - Cache

    private var cache: [CacheKey: DateFormatter] = [:]
    private let lock = NSLock()

    private struct CacheKey: Hashable {
        let format: String
        let timeZone: String?
    }

    // MARK: - Formatter Builder

    private func formatter(
        format: DateFormat,
        timeZone: TimeZone?
    ) -> DateFormatter {

        let key = CacheKey(
            format: format.rawValue,
            timeZone: timeZone?.identifier
        )

        lock.lock()
        defer { lock.unlock() }

        if let cached = cache[key] {
            return cached
        }

        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX") // Critical

        cache[key] = formatter
        return formatter
    }

    // MARK: - Public API

    /// String → Date (tries all formats)
    public func toDate(
        _ string: String,
        timeZone: TimeZone? = .gmt
    ) -> Date? {

        for format in DateFormat.allCases {
            let formatter = formatter(format: format, timeZone: timeZone)
            if let date = formatter.date(from: string) {
                return date
            }
        }

        return nil
    }

    /// Date → String
    public func toString(
        _ date: Date,
        format: DateFormat,
        timeZone: TimeZone? = .gmt
    ) -> String {

        formatter(format: format, timeZone: timeZone)
            .string(from: date)
    }

    /// String → String (parse + format)
    public func convert(
        _ string: String,
        to format: DateFormat,
        inputTimeZone: TimeZone? = .gmt,
        outputTimeZone: TimeZone? = .gmt
    ) -> String {

        guard let date = toDate(string, timeZone: inputTimeZone) else {
            return ""
        }

        return toString(date, format: format, timeZone: outputTimeZone)
    }

    /// String → Date (normalized output format)
    public func convertToDate(
        _ string: String,
        to format: DateFormat,
        inputTimeZone: TimeZone? = .gmt,
        outputTimeZone: TimeZone? = .gmt
    ) -> Date? {

        guard let date = toDate(string, timeZone: inputTimeZone) else {
            return nil
        }

        let formatted = toString(date, format: format, timeZone: outputTimeZone)
        return formatter(format: format, timeZone: outputTimeZone)
            .date(from: formatted)
    }
}
