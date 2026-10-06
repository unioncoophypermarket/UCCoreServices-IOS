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
    case ddMMyyyySlash = "dd/MM/yyyy"
    case ddMMyyyyDash = "dd-MM-yyyy"
    case ddMMyyyyColon = "dd:MM:yyyy"
    case ddMMyyyyColonHHmm = "dd:MM:yyyy HH:mm"
    case ddMMMyyyyDash = "dd-MMM-yyyy"

    case ddMMyyyyDashHHmm = "dd-MM-yyyy HH:mm"
    case ddMMyyyyDashHHmmss = "dd-MM-yyyy HH:mm:ss"

    case dMMMMyyyy = "d MMMM, yyyy"
    case dMMMyyyy = "d MMM yyyy"
    case mmmDyyyy = "MMM d yyyy"
    case mmmDDyyyy = "MMM dd yyyy"
    case monthAbbreviated = "MMM"
    case dayOnly = "dd"
    case dayMonthFull = "d MMMM"
    case ddMMM = "dd MMM"
    case ddMMMDash = "dd-MMM"

    case dateWithTime = "d MMMM, yyyy • hh:mm:ss a"

    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMdd = "yyyy-MM-dd"

    case isoWithoutMilliseconds = "yyyy-MM-dd'T'HH:mm:ss"
    case isoWithZ = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    case isoWithShortMillisecondsZ = "yyyy-MM-dd'T'HH:mm:ss.SS'Z'"
    case isoWithMillisecondsZ = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case isoWithOffset = "yyyy-MM-dd'T'HH:mm:ssXXXXX"

    case weekdayFormat = "EEEE, d MMM 'at' h:mm a"
    case shortWeekdaySlash = "E, dd/MM/yy"
    case timeOnly = "h:mm a"
    case mmmDyyyyTime = "MMM d yyyy h:mma"
    case ddMMyyyyTTime = "dd-MM-yyyy'T'h:mma"

    case ddMMMyyyyCommaShortTime = "dd MMM yyyy, hh:mm a"
    case ddMMMyyyyCommaTime = "dd MMM yyyy, hh:mm:ss a"

    case isoWithNanosecondsAndZone = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSXXXXX"
    case isoDefault = "yyyy-MM-dd'T'HH:mm:ss.SSS"
}
