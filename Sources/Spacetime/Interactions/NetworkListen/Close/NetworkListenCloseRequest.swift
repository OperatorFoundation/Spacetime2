//
//  NetworkCloseRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/9/22.
//

import Foundation

public class NetworkListenCloseRequest: Effect
{
    public let socketId: UUID

    public init(_ socketId: UUID)
    {
        self.socketId = socketId

        super.init(module: BuiltinModuleNames.networkListen.rawValue)
    }
}
