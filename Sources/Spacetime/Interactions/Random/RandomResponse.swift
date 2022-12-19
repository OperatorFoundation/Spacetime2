//
//  RandomResponse.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class RandomResponse: Event
{
    public let value: UInt64

    public override var description: String
    {
        return "\(self.module).RandomResponse[effectId: \(String(describing: self.effectId)), value: \(value)]"
    }

    public init(_ effectId: UUID, _ value: UInt64)
    {
        self.value = value
        
        super.init(effectId, module: BuiltinModuleNames.random.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case value
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let value = try container.decode(UInt64.self, forKey: .value)

        self.value = value
        super.init(effectId, module: BuiltinModuleNames.random.rawValue)
    }
}
