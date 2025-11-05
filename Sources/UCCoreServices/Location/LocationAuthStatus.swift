//
//  LocationAuthStatus.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 05/11/2025.
//

import Foundation

public enum LocationAuthStatus: Sendable {
    case notDetermined, restricted, denied, authorizedWhenInUse, authorizedAlways
}
