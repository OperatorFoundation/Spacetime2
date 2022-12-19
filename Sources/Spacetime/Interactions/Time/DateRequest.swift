//
//  DateRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DateRequest: Effect
{
    public override var description: String
    {
        return "\(self.module).DateRequest[id: \(self.id)]"
    }

    public init()
    {
        super.init(module: BuiltinModuleNames.time.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)

        super.init(id: id, module: BuiltinModuleNames.time.rawValue)
    }
}
