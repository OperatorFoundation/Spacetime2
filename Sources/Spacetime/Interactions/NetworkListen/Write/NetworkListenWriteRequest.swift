//
//  NetworkWriteRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation
import SwiftHexTools

public class NetworkListenWriteRequest: Effect
{
    public let socketId: UUID
    public let data: Data
    public let lengthPrefixSizeInBits: Int?

    public override var description: String
    {
        return "\(self.module).NetworkListenWriteRequest[id: \(self.id), socketId: \(self.socketId), data: \(self.data), lengthPrefixSizeInBits: \(String(describing: self.lengthPrefixSizeInBits))]"
    }

    public init(_ socketId: UUID, _ data: Data, _ lengthPrefixSizeInBits: Int? = nil)
    {
        self.socketId = socketId
        self.data = data
        self.lengthPrefixSizeInBits = lengthPrefixSizeInBits

        super.init(module: BuiltinModuleNames.networkListen.rawValue)
    }
}
