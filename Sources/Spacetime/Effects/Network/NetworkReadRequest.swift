//
//  NetworkReadRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class NetworkReadRequest: Effect
{
    public let socketId: UUID
    public let length: UInt64

    public init(_ socketId: UUID, _ length: UInt64)
    {
        self.socketId = socketId
        self.length = length
    }
}
