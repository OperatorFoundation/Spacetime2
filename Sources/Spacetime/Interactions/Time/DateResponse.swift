//
//  DateResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DateResponse: Event
{
    public let date: Date

    public override var description: String
    {
        return "\(self.module).DateResponse[effectId: \(String(describing: self.effectId)), date: \(date)]"
    }

    public init(_ effectId: UUID, _ date: Date)
    {
        self.date = date
        
        super.init(effectId, module: BuiltinModuleNames.time.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case date
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let date = try container.decode(Date.self, forKey: .date)

        self.date = date
        super.init(effectId, module: BuiltinModuleNames.time.rawValue)
    }
}
