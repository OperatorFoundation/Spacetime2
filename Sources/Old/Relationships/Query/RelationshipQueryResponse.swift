//
//  RelationshipQueryResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class RelationshipQueryResponse: Event
{
    public let results: [Relationship]

    public override var description: String
    {
        return "\(self.module).DataSaveResponse[effectID: \(String(describing: self.effectId)), results: \(self.results)]"
    }

    public init(_ effectId: UUID, _ results: [Relationship])
    {
        self.results = results

        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case results
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let results = try container.decode([Relationship].self, forKey: .results)

        self.results = results
        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }
}
