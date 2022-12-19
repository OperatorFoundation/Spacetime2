//
//  Failure.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class Failure: Event
{
    public override var description: String
    {
        return "\(self.module).Affected[effectID: \(String(describing: self.effectId))]"
    }

    public init(_ effectId: UUID)
    {
        super.init(effectId, module: BuiltinModuleNames.general.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)

        super.init(effectId, module: BuiltinModuleNames.general.rawValue)
    }
}
