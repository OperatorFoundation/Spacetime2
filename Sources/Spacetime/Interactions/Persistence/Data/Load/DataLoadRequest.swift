//
//  CodableLoadRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class DataLoadRequest: Effect
{
    public let dataId: UInt64

    public override var description: String
    {
        return "\(self.module).DataLoadRequest[id: \(self.id), dataId: \(self.dataId)]"
    }

    public init(dataId: UInt64)
    {
        self.dataId = dataId

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }
}
