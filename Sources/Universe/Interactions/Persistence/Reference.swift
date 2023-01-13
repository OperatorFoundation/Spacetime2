//
//  Reference.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/13/23.
//

import Foundation

public class Reference<T>
{
    static public func load(universe: Universe, identifier: UInt64) throws -> Reference<T>
    {
        let object: T = try universe.load(identifier: identifier)
        return Reference(universe: universe, identifier: identifier, object: object)
    }

    public let universe: Universe
    public let identifier: UInt64
    public let object: T
    public let type: String

    public convenience init(universe: Universe, identifier: UInt64) throws
    {
        let object: T = try universe.load(identifier: identifier)
        self.init(universe: universe, identifier: identifier, object: object)
    }

    public init(universe: Universe, identifier: UInt64, object: T)
    {
        self.universe = universe
        self.identifier = identifier
        self.object = object
        self.type = "\(Swift.type(of: object))"
    }

    public func save() throws
    {
        try self.universe.save(identifier: self.identifier, type: self.type, object: self.object)
    }

    public func delete() throws
    {
        let _ = try self.universe.delete(identifier: self.identifier)
    }

    public func copy() throws -> Reference<T>
    {
        let newId = try self.universe.allocateIdentifier()
        return Reference(universe: self.universe, identifier: newId, object: self.object)
    }
}
