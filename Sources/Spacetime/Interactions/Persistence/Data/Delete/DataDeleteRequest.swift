//
//  CodableDeleteRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class DataDeleteRequest: Effect
{
    public let dataId: UInt64

    public init(dataId: UInt64)
    {
        self.dataId = dataId

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }
}
