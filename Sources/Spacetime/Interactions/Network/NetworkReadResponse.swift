//
//  NetworkReadResponse.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class NetworkReadResponse: Event
{
    public let socketId: UUID
    public let data: Data

    public init(_ effectId: UUID, _ socketId: UUID, _ data: Data)
    {
        self.socketId = socketId
        self.data = data

        super.init(effectId)
    }
}
