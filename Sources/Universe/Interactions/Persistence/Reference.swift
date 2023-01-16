//
//  Reference.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/13/23.
//

import Foundation

public class Reference<T> where T: Codable
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

    public convenience init(universe: Universe, object: T) throws
    {
        let identifier = try universe.allocateIdentifier()
        self.init(universe: universe, identifier: identifier, object: object)

        try self.save()

        try self.universe.append(type: type, identifier: identifier)
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
        try self.universe.save(identifier: self.identifier, object: self.object)
    }

    public func delete() throws
    {
        let _ = try self.universe.delete(identifier: self.identifier)
        try self.universe.delete(type: self.type, identifier: self.identifier)
    }

    public func copy() throws -> Reference<T>
    {
        return try Reference(universe: self.universe, object: self.object)
    }
}
