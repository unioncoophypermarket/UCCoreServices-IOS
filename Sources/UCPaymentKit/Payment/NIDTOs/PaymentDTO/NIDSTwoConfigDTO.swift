//
//  NIDSTwoConfigDTO.swift
//  UCPaymentKit
//
//  Created by Mahmoud Alaa on 04/12/2025.
//

import Foundation

public struct NIDSTwoConfigDTO: Decodable {
    public let threeDSMethodURL: String?
    public let messageVersion: String?
    public let threeDSServerTransID: String?
    public let directoryServerID: String?
}
