//
//  StarburstRequest.swift
//  
//
//  Created by Joshua Clark on 7/22/22.
//

import Foundation

public class StarburstRequest: Effect
{
    public override var description: String
    {
        return "\(self.module).StarburstRequest[id: \(self.id)]"
    }

    public init()
    {
        super.init(module: BuiltinModuleNames.starburst.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)

        super.init(id: id, module: BuiltinModuleNames.starburst.rawValue)
    }
}
