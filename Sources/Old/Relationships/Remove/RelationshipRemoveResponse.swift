//
//  RelationshipRemoveResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class RelationshipRemoveResponse: Event
{
    public let success: Bool

    public override var description: String
    {
        return "\(self.module).RelationshipRemoveResponse[effectID: \(String(describing: self.effectId)), success: \(self.success)]"
    }

    public init(_ effectId: UUID, _ success: Bool)
    {
        self.success = success

        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case success
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let success = try container.decode(Bool.self, forKey: .success)

        self.success = success
        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }
}
