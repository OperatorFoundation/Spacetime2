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

    public init(subject: UInt64?, relation: Relation?, object: UInt64?)
    {
        self.subject = subject
        self.relation = relation
        self.object = object

        super.init()
    }
}
