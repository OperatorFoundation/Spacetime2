//
//  NetworkReadRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class NetworkListenReadRequest: Effect
{
    public let socketId: UUID
    public let style: NetworkListenReadStyle

    public override var description: String
    {
        return "\(self.module).NetworkListenReadRequest[id: \(self.id), socketId: \(self.socketId), style: \(self.style)]"
    }

    public init(_ socketId: UUID, _ style: NetworkListenReadStyle)
    {
        self.socketId = socketId
        self.style = style

        super.init(module: BuiltinModuleNames.networkListen.rawValue)
    }
}

public enum NetworkListenReadStyle
{
    case exactSize(Int)
    case maxSize(Int)
    case lengthPrefixSizeInBits(Int)
}

extension NetworkListenReadStyle: CustomStringConvertible
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
