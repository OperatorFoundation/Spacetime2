//
//  RelationshipQueryRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class RelationshipQueryRequest: Effect
{
    public let subject: UInt64?
    public let relation: Relation?
    public let object: UInt64?

    public override var description: String
    {
        return "\(self.module).RelationshipQueryRequest[id: \(self.id), subject: \(String(describing: self.subject)), relation: \(String(describing: self.relation)), object: \(String(describing: self.object))]"
    }

    public init(subject: UInt64?, relation: Relation?, object: UInt64?)
    {
        self.subject = subject
        self.relation = relation
        self.object = object

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case id
        case subject
        case relation
        case object
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let subject = try container.decode(UInt64?.self, forKey: .subject)
        let relation = try container.decode(Relation.self, forKey: .relation)
        let object = try container.decode(UInt64?.self, forKey: .object)

        self.subject = subject
        self.relation = relation
        self.object = object
        super.init(id: id, module: BuiltinModuleNames.persistence.rawValue)
    }
}
