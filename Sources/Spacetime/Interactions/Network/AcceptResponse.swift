//
//  AcceptResponse.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class AcceptResponse: Event
{
    public let socketId: UUID

    public init(_ effectId: UUID, _ socketId: UUID)
    {
        self.socketId = socketId

        super.init(effectId)
    }
}
