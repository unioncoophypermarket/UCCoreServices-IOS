//
//  MapOpening.swift
//  UCCoreServices
//
//  Created by Mahmoud Alaa on 05/11/2025.
//

import Foundation

@MainActor
public protocol MapOpening: Sendable {
    func openDriving(to coordinate: UCCoordinate)
}
