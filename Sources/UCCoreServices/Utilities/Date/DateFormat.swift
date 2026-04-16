//
//  DateFormat.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 16/04/2026.
//

import Foundation

public enum DateFormat: String, CaseIterable, Sendable {

    case ddMMyyyyDots = "dd.MM.yy"
    case mmddyyyySlash = "MM/dd/yyyy"
    case ddMMyyyyDash = "dd-MM-yyyy"
    case ddMMMyyyyDash = "dd-MMM-yyyy"

    case ddMMyyyyDashHHmm = "dd-MM-yyyy HH:mm"
    case ddMMyyyyDashHHmmss = "dd-MM-yyyy HH:mm:ss"

    case dMMMMyyyy = "d MMMM, yyyy"
    case dMMMyyyy = "d MMM yyyy"
    case mmmDyyyy = "MMM d yyyy"
    case ddMMM = "dd MMM"

    case dateWithTime = "d MMMM, yyyy • hh:mm:ss a"

    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMdd = "yyyy-MM-dd"

    case isoWithoutMilliseconds = "yyyy-MM-dd'T'HH:mm:ss"
    case isoWithZ = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case isoWithMillisecondsZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

    case weekdayFormat = "EEEE, d MMM 'at' h:mm a"
    case shortWeekdaySlash = "E, dd/MM/yy"
    case timeOnly = "h:mm a"

    case ddMMMyyyyCommaTime = "dd MMM yyyy, hh:mm:ss a"

    case isoWithNanosecondsAndZone = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSXXXXX"
    case isoDefault = "yyyy-MM-dd'T'HH:mm:ss.SSS"
}
