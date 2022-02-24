//
//  NetworkWriteRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class NetworkWriteRequest: Effect
{
    public let socketId: UUID
    public let data: Data

    public init(_ socketId: UUID, _ data: Data)
    {
        self.socketId = socketId
        self.data = data
    }
}
