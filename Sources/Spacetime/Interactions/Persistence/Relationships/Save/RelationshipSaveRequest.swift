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

    public init(_ relationship: Relationship)
    {
        self.relationship = relationship

        super.init(module: BuiltinModuleNames.persistence.rawValue)
    }
}
