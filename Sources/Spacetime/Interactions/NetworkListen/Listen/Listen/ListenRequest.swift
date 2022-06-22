//
//  ListenRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

import TransmissionTypes

public class ListenRequest: Effect
{
    public let address: String?
    public let port: Int
    public let type: ConnectionType

    public override var description: String
    {
        return "\(self.module).ListenRequest[id: \(self.id), address: \(String(describing: self.address)), port: \(self.port), type: \(self.type)]"
    }

    public init(_ address: String?, _ port: Int, _ type: ConnectionType)
    {
        self.address = address
        self.port = port
        self.type = type

        super.init(module: BuiltinModuleNames.networkListen.rawValue)
    }
}
