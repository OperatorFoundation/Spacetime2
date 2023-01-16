//
//  Persistence.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/9/23.
//

import Foundation

import ParchmentFile
import Spacetime

public class Persistence
{
    let data: DataDatabase
    let index: IndexDatabase
    let relationship: RelationshipDatabase

    public init(root: String) throws
    {
        self.data = DataDatabase(root: root)
        self.index = try IndexDatabase(root: root)
        self.relationship = RelationshipDatabase(root: root)
    }

    // Data
    public func allocateIdentifier() throws -> UInt64
    {
        guard let result = self.data.allocateIdentifier() else
        {
            throw PersistenceError.allocationFailed
        }

        return result
    }

    public func exists(identifier: UInt64) -> Bool
    {
        return self.data.exists(identifier: identifier)
    }

    public func loadData(identifier: UInt64) throws -> Data
    {
        return try self.data.getStatic(identifier: identifier)
    }

    public func saveData(identifier: UInt64, type: String, data: Data) throws
    {
        return try self.data.save(identifier: identifier, type: type, data: data)
    }

    public func deleteData(identifier: UInt64) -> Bool
    {
        return self.data.delete(identifier: identifier)
    }

    // Index
    public func count(type: String) throws -> Int
    {
        guard let result = try self.index.count(type: type) else
        {
            throw PersistenceError.fileNotFound
        }

        return Int(result)
    }

    public func load(type: String, offset: Int) throws -> UInt64
    {
        guard let result = try self.index.load(type: type, offset: offset) else
        {
            throw PersistenceError.loadFailed
        }

        return result
    }

    public func append(type: String, identifier: UInt64) throws
    {
        try self.index.append(type: type, identifier: identifier)
    }

    public func delete(type: String, identifier: UInt64) throws
    {
        try self.index.delete(type: type, identifier: identifier)
    }

    // Relationship
    public func query(subject: UInt64?, relation: Relation?, object: UInt64?) -> [Relationship]
    {
        return self.relationship.query(subject: subject, relation: relation, object: object)
    }

    public func saveRelationship(relationship: Relationship) throws
    {
        try self.relationship.save(relationship: relationship)
    }

    public func deleteRelationship(relationship: Relationship) throws
    {
        try self.relationship.remove(relationship: relationship)
    }
}

public enum PersistenceError: Error
{
    case allocationFailed
    case fileNotFound
    case loadFailed
}
