//
//  LocationProviding.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 05/11/2025.
//

import Foundation

public protocol LocationProviding: Sendable {
    /// Start continuous updates (UI decides when to start/stop).
    func startUpdates()
    func stopUpdates()

    /// One-shot location; should prompt for permission if needed.
    func requestOneShot() async throws -> UCCoordinate

    /// Last known coordinate, if any.
    var current: UCCoordinate? { get }

    /// Is location effectively usable right now?
    func isLocationEnabled() -> Bool

    /// Current authorization status.
    func authorizationStatus() -> LocationAuthStatus
}
