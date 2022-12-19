//
//  RandomRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class RandomRequest: Effect
{
    public override var description: String
    {
        return "\(self.module).RandomRequest[id: \(self.id)]"
    }

    public init()
    {
        super.init(module: BuiltinModuleNames.random.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)

        super.init(id: id, module: BuiltinModuleNames.random.rawValue)
    }
}
