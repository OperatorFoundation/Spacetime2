//
//  Universe+Amber.swift
//  Spacetime
//
//  Created by Dr. Brandon Wiley on 10/11/21.
//

import Foundation

import Amber
import Datable
import ParchmentFile

extension Universe
{
    // References
    public func delete<T>(reference: Reference<T>) throws
    {
        try reference.delete()
    }

    public func loadReference<T>(identifier: UInt64) throws -> Reference<T>
    {
        return try Reference(universe: self, identifier: identifier)
    }

    public func load<T>() throws -> IndexedCollection<T> where T: Codable
    {
        return try IndexedCollection(universe: self)
    }

    public func new<T>(object: T) throws -> Reference<T> where T: Codable
    {
        return try Reference(universe: self, object: object)
    }

    public func save<T>(reference: Reference<T>) throws
    {
        try reference.save()
    }

    // Codables
    public func delete(identifier: UInt64) throws -> Bool
    {
        return try self.deleteData(identifier: identifier)
    }

    public func load<T>(identifier: UInt64) throws -> T where T: Codable
    {
        let data = try self.loadData(identifier: identifier)
        let types = Types.type(String(describing: T.self))
        let anyResult = try Amber.load(data)
        guard let result = anyResult as? T else
        {
            throw AmberDatabaseError.wrongType
        }

        return result
    }

    public func save<T>(identifier: UInt64, object: T) throws where T: Codable
    {
        let data = try Amber.save(object)
        let typeName = String("\(type(of: T.self))".split(separator: " ")[0])
        try self.saveData(identifier: identifier, type: typeName, data: data)
    }
}

public enum AmberDatabaseError: Error
{
    case wrongType
}
