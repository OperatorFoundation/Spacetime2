//
//  StarburstResponse.swift
//  
//
//  Created by Joshua Clark on 7/22/22.
//

import Foundation

public class StarburstResponse: Event
{
    public let message: Data

    public override var description: String
    {
        return "\(self.module).StarburstResponse[effectId: \(String(describing: self.effectId)), message: \(message)]"
    }

    public init(_ effectId: UUID, _ message: Data)
    {
        self.message = message
        
        super.init(effectId, module: BuiltinModuleNames.starburst.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case message
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let message = try container.decode(Data.self, forKey: .message)

        self.message = message
        super.init(effectId, module: BuiltinModuleNames.starburst.rawValue)
    }
}
