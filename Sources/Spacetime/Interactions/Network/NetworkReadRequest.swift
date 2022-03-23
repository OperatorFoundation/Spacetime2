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

        super.init()
    }
}

public enum NetworkReadStyle
{
    case exactSize(Int)
    case maxSize(Int)
    case lengthPrefixSizeInBits(Int)
}

extension NetworkReadStyle: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
            case .exactSize(let size):
                return ".exactSize(\(size))"
            case .maxSize(let size):
                return ".maxSize(\(size))"
            case .lengthPrefixSizeInBits(let bits):
                return ".lengthPrefixSizeInBits(\(bits))"
        }
    }
}
