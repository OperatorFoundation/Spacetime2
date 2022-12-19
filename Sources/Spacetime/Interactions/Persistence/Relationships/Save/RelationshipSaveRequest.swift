//
//  RelationshipSaveRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class RelationshipSaveRequest: Effect
{
    public let relationship: Relationship

    public override var description: String
    {
        return "\(self.module).RelationshipSaveRequest[id: \(self.id), relationship: \(self.relationship)]"
    }

    public init(_ relationship: Relationship)
    {
        self.relationship = relationship

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case relationship
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let relationship = try container.decode(Relationship.self, forKey: .relationship)

        self.relationship = relationship
        super.init(id: id, module: BuiltinModuleNames.persistence.rawValue)
    }
}
