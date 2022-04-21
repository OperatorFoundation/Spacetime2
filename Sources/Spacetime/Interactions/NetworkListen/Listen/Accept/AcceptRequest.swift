//
//  AcceptRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class AcceptRequest: Effect
{
    public let socketId: UUID

    public override var description: String
    {
        return "\(self.module).AcceptRequest[id: \(self.id), socketId: \(self.socketId)]"
    }

    public init(_ socketId: UUID)
    {
        self.socketId = socketId

        super.init(module: BuiltinModuleNames.networkListen.rawValue)
    }
}
