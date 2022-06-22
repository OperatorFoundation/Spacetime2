//
//  NetworkWriteResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class NetworkListenWriteResponse: Event
{
    public override var description: String
    {
        return "\(self.module).NetworkListenWriteResponse[effectID: \(String(describing: self.effectId))]"
    }

    public init(_ effectId: UUID)
    {
        super.init(effectId, module: BuiltinModuleNames.networkListen.rawValue)
    }
}
