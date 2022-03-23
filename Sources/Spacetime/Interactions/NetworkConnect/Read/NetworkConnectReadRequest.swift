//
//  NetworkReadRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class NetworkConnectReadRequest: Effect
{
    public let socketId: UUID
    public let style: NetworkConnectReadStyle

    public init(_ socketId: UUID, _ style: NetworkConnectReadStyle)
    {
        self.socketId = socketId
        self.style = style

        super.init(module: BuiltinModuleNames.networkConnect.rawValue)
    }
}

public enum NetworkConnectReadStyle
{
    case exactSize(Int)
    case maxSize(Int)
    case lengthPrefixSizeInBits(Int)
}

extension NetworkConnectReadStyle: CustomStringConvertible
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
