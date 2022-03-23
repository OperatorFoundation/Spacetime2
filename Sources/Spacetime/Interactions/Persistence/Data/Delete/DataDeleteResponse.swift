//
//  CodableDeleteResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class DataDeleteResponse: Event
{
    public let dataId: UInt64
    public let success: Bool

    public init(_ effectId: UUID, _ dataId: UInt64, success: Bool)
    {
        self.dataId = dataId
        self.success = success

        super.init(effectId)
    }
}
