//
//  DisplayList.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DisplayList: Effect
{
    public let list: [String]

    public override var description: String
    {
        return "\(self.module).DisplayList[id: \(self.id) list: \(self.list)]"
    }

    public init(_ list: [String])
    {
        self.list = list

        super.init(module: BuiltinModuleNames.display.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case list
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let list = try container.decode([String].self, forKey: .list)

        self.list = list
        super.init(id: id, module: BuiltinModuleNames.display.rawValue)
    }
}
