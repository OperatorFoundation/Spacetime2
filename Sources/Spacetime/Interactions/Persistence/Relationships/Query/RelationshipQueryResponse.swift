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

    public init(_ effectId: UUID, _ results: [Relationship])
    {
        self.results = results

        super.init(effectId, module: BuiltinModuleNames.persistence.rawValue)
    }
}
