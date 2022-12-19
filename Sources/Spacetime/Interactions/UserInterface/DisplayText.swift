//
//  DisplayText.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DisplayText: Effect
{
    public let string: String

    public override var description: String
    {
        return "\(self.module).DisplayText[id: \(self.id) string: \(self.string)]"
    }

    public init(_ string: String)
    {
        self.string = string

        super.init(module: BuiltinModuleNames.display.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case string
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let string = try container.decode(String.self, forKey: .string)

        self.string = string
        super.init(id: id, module: BuiltinModuleNames.display.rawValue)
    }
}
