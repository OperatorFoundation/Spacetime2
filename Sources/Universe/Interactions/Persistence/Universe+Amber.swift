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
    public func load<T>() throws -> IndexedCollection<T> where T: Codable
    {
        return try IndexedCollection(universe: self)
    }

    public func load<T>(type: String) throws -> [T] where T: Codable
    {
        let iterator: AmberIterator<T> = AmberIterator(type: type, universe: self)

        var results: [T] = []
        while true
        {
            guard let user = iterator.next() else
            {
                return results
            }

            results.append(user)
        }

        return results
    }

    public func load<T>(identifier: UInt64) throws -> Reference<T>
    {
        return try Reference(universe: self, identifier: identifier)
    }

    public func load<T>(identifier: UInt64) throws -> T
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

    public func save<T>(reference: Reference<T>) throws
    {
        try reference.save()
    }

    // FIXME - update index
    public func save<T>(identifier: UInt64, object: T) throws
    {
        let data = try Amber.save(object)
        let typeName = "\(type(of: T.self))"
        try self.saveData(identifier: identifier, type: typeName, data: data)
    }

    public func delete<T>(reference: Reference<T>) throws
    {
        try reference.delete()
    }

    // FIXME - update index
    public func delete(identifier: UInt64) throws -> Bool
    {
        return try self.deleteData(identifier: identifier)
    }
}

public enum AmberDatabaseError: Error
{
    case wrongType
}
