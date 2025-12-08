//
//  NetworkErrorLocalizableKeys.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 13/04/2026.
//

import Foundation

class NetworkErrorLocalizableKeys {

    static var sessionExpired: String {
        return NSLocalizedString("Session Expired", comment: "")
    }
    
    static var sessionExpiredPleaseLoginMessage: String {
        return NSLocalizedString("Your session has expired. Please log in again.", comment: "")
    }

    static var sessionExpiredMessage: String {
        return NSLocalizedString("Your session has expired.", comment: "")
    }

    /// EN: Server did not respond.
    /// AR: لم نتلقَ ردًا من الخادم.
    static var noServerResponse: String {
        NSLocalizedString("We couldn’t reach the server right now. Please try again.", comment: "")
    }

    /// EN: Data processing issue.
    /// AR: حدثت مشكلة أثناء تحميل البيانات.
    static var parsingError: String {
        NSLocalizedString("We’re having trouble loading this information. Please try again.", comment: "")
    }

    /// EN: No internet connection.
    /// AR: لا يوجد اتصال بالإنترنت.
    static var noInternetConnection: String {
        NSLocalizedString("You appear to be offline. Please check your internet connection.", comment: "")
    }


    /// EN: Invalid request.
    /// AR: حدثت مشكلة في الطلب.
    static var invalidURL: String {
        NSLocalizedString("Something went wrong with the request. Please try again.", comment: "")
    }

    /// EN: Action not allowed.
    /// AR: لا يمكنك تنفيذ هذا الإجراء.
    static var forbidden: String {
        NSLocalizedString("You’re not allowed to do this action.", comment: "")
    }

    /// EN: Item not found.
    /// AR: لم نتمكن من العثور على المحتوى المطلوب.
    static var notFound: String {
        NSLocalizedString("We couldn’t find what you’re looking for.", comment: "")
    }

    /// EN: Server error.
    /// AR: مشكلة مؤقتة في الخادم.
    static var serverError: String {
        NSLocalizedString("We’re experiencing a temporary issue. Please try again later.", comment: "")
    }

    /// EN: Fallback error.
    /// AR: حدث خطأ غير متوقع.
    static var unexpectedError: String {
        NSLocalizedString("Something didn’t go as expected. Please try again.", comment: "")
    }
}
