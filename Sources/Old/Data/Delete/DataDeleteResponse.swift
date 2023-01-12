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

    public override var description: String
    {
        return "\(self.module).DataDeleteResponse[effectID: \(String(describing: self.effectId)), dataId: \(self.dataId), success: \(self.success)]"
    }

    public init(_ effectId: UUID, _ dataId: UInt64, success: Bool)
    {
        self.dataId = dataId
        self.success = success

        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case dataId
        case success
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let dataId = try container.decode(UInt64.self, forKey: .dataId)
        let success = try container.decode(Bool.self, forKey: .success)

        self.dataId = dataId
        self.success = success
        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }
}
