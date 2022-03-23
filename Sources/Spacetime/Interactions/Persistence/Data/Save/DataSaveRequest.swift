//
//  CodableSaveRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class DataSaveRequest: Effect
{
    public let dataId: UInt64
    public let type: String
    public let data: Data

    public init(dataId: UInt64, type: String, data: Data)
    {
        self.dataId = dataId
        self.type = type
        self.data = data

        super.init()
    }
}
