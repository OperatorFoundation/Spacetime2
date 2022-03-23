//
//  NetworkWriteRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation
import SwiftHexTools

public class NetworkWriteRequest: Effect
{
    public let socketId: UUID
    public let data: Data
    public let lengthPrefixSizeInBits: Int?

    public init(_ socketId: UUID, _ data: Data, _ lengthPrefixSizeInBits: Int? = nil)
    {
        self.socketId = socketId
        self.data = data
        self.lengthPrefixSizeInBits = lengthPrefixSizeInBits

        super.init()
    }
}
