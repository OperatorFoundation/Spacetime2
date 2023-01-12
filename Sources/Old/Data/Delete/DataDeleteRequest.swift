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

    public override var description: String
    {
        return "\(self.module).DataDeleteRequest[id: \(self.id), dataId: \(self.dataId)]"
    }

    public init(dataId: UInt64)
    {
        self.dataId = dataId

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case dataId
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let dataId = try container.decode(UInt64.self, forKey: .dataId)

        self.dataId = dataId
        super.init(id: id, module: BuiltinModuleNames.persistence.rawValue)
    }
}
