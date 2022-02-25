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
    public let style: NetworkReadStyle

    public init(_ socketId: UUID, _ style: NetworkReadStyle)
    {
        self.socketId = socketId
        self.style = style
    }
}

public enum NetworkReadStyle
{
    case exactSize(Int)
    case maxSize(Int)
    case lengthPrefixSizeInBits(Int)
}
