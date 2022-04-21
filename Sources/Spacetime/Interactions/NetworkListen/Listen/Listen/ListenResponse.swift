//
//  ListenResponse.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class ListenResponse: Event
{
    public let socketId: UUID

    public override var description: String
    {
        return "\(self.module).ListenResponse[effectID: \(String(describing: self.effectId)), socketId: \(self.socketId)]"
    }

    public init(_ effectId: UUID, _ socketId: UUID)
    {
        self.socketId = socketId

        super.init(effectId, module: BuiltinModuleNames.networkListen.rawValue)
    }
}
