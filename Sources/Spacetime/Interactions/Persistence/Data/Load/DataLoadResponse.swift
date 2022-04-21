//
//  CodableLoadResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class DataLoadResponse: Event
{
    public let dataId: UInt64
    public let success: Bool
    public let data: Data?

    public override var description: String
    {
        return "\(self.module).DataDeleteResponse[effectID: \(String(describing: self.effectId)), dataId: \(self.dataId), success: \(self.success), data: \(self.data)]"
    }

    public init(_ effectId: UUID, _ dataId: UInt64, success: Bool, data: Data?)
    {
        self.dataId = dataId
        self.success = success
        self.data = data

        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }
}
