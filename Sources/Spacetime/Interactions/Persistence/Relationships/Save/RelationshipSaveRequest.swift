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
}
