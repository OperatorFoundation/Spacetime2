//
//  Universe+Relationship.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/16/23.
//

import Foundation

import Spacetime

extension Universe
{
    public func query(relation: Relation) throws -> [Relationship]
    {
        return try self.query(subject: nil, relation: relation, object: nil)
    }

    public func query<S>(subject: Reference<S>, relation: Relation) throws -> [Relationship]
    {
        return try self.query(subject: subject.identifier, relation: relation, object: nil)
    }

    public func query<O>(relation: Relation, object: Reference<O>) throws -> [Relationship]
    {
        return try self.query(subject: nil, relation: relation, object: nil)
    }

    public func query<S, O>(subject: Reference<S>, relation: Relation, object: Reference<O>) throws -> [Relationship]
    {
        return try self.query(subject: subject.identifier, relation: relation, object: object.identifier)
    }
}
