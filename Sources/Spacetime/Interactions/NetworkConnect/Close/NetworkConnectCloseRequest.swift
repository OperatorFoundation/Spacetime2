//
//  NetworkCloseRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/9/22.
//

import Foundation

public class NetworkConnectCloseRequest: Effect
{
    public let socketId: UUID

    public override var description: String
    {
        return "\(self.module).NetworkConnectCloseRequest[id: \(self.id), socketId: \(self.socketId)]"
    }

    public init(_ socketId: UUID)
    {
        self.socketId = socketId

        super.init(module: BuiltinModuleNames.networkConnect.rawValue)
    }
}
