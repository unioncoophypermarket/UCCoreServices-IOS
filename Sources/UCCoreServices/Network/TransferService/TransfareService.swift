//
//  TransfareService.swift
//  UnionCoop
//
//  Created by Mahmoud Alaa on 9/18/23.
//

import Foundation
public import UCNetworkKit

public protocol TransferService: Sendable {
    func service() -> DataTransferService
}
