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

    public override var description: String
    {
        return "\(self.module).DataSaveRequest[id: \(self.id), dataId: \(self.dataId), type: \(self.type), data: \(self.data)]"
    }

    public init(dataId: UInt64, type: String, data: Data)
    {
        self.dataId = dataId
        self.type = type
        self.data = data

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case dataId
        case type
        case data
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let dataId = try container.decode(UInt64.self, forKey: .dataId)
        let type = try container.decode(String.self, forKey: .type)
        let data = try container.decode(Data.self, forKey: .data)

        self.dataId = dataId
        self.type = type
        self.data = data
        super.init(id: id, module: BuiltinModuleNames.persistence.rawValue)
    }
}
