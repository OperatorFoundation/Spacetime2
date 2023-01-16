//
//  Reference.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/13/23.
//

import Foundation

public class Reference<T>: Codable where T: Codable
{
    enum CodingKeys: String, CodingKey
    {
        case identifier
        case object
    }

    static public func load(universe: Universe, identifier: UInt64) throws -> Reference<T>
    {
        let object: T = try universe.load(identifier: identifier)
        return Reference(universe: universe, identifier: identifier, object: object)
    }

    public let universe: Universe?
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

        try universe.append(type: type, identifier: identifier)
    }

    public init(universe: Universe?, identifier: UInt64, object: T)
    {
        self.universe = universe
        self.identifier = identifier
        self.object = object
        self.type = "\(Swift.type(of: object))"
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(UInt64.self, forKey: CodingKeys.identifier)
        let object = try container.decode(T.self, forKey: CodingKeys.object)
        self.object = object

        self.type = "\(Swift.type(of: object))"
        self.universe = nil
    }

    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.identifier, forKey: CodingKeys.identifier)
        try container.encode(self.object, forKey: CodingKeys.object)
    }

    public func save() throws
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        try universe.save(identifier: self.identifier, object: self.object)
    }

    public func delete() throws
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        let _ = try universe.delete(identifier: self.identifier)
        try universe.delete(type: self.type, identifier: self.identifier)
    }

    public func copy() throws -> Reference<T>
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        return try Reference(universe: universe, object: self.object)
    }
}

public enum ReferenceError: Error
{
    case noUniverse
}
