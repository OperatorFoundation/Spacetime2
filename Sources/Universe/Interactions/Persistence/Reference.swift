//
//  Reference.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/13/23.
//

import Foundation

public class Reference<T>: Codable where T: Codable, T: Equatable
{
    // Private data structures
    enum CodingKeys: String, CodingKey
    {
        case identifier
        case object
    }

    // Static public functions
    static public func load(universe: Universe, identifier: UInt64) throws -> Reference<T>
    {
        let object: T = try universe.load(identifier: identifier)
        return Reference(universe: universe, identifier: identifier, object: object)
    }

    // Public lets
    public let identifier: UInt64
    public let object: T
    public let type: String

    // Public vars
    public var universe: Universe?

    // Public inits
    public convenience init(universe: Universe, identifier: UInt64) throws
    {
        // Create a Reference to an existing object using its identifier
        let object: T = try universe.load(identifier: identifier)
        self.init(universe: universe, identifier: identifier, object: object)
    }

    public convenience init(universe: Universe, object: T) throws
    {
        // Create a reference to a new object, using a newly allocated identifier
        let identifier = try universe.allocateIdentifier()
        self.init(universe: universe, identifier: identifier, object: object)

        try self.save()

        try universe.append(type: type, identifier: identifier)
    }

    public init(universe: Universe?, identifier: UInt64, object: T)
    {
        // Create a reference by specifying all parameters
        self.universe = universe
        self.identifier = identifier
        self.object = object
        self.type = String("\(Swift.type(of: object))".split(separator: ".")[0])
    }

    // Codable implementation
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

    // Public functions
    public func connect(universe: Universe)
    {
        self.universe = universe
    }

    public func copy() throws -> Reference<T>
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        return try Reference(universe: universe, object: self.object)
    }

    public func delete() throws
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        let _ = try universe.delete(identifier: self.identifier)
        try universe.delete(type: self.type, identifier: self.identifier)

        let subjectRelationships = try universe.query(subject: self.identifier, relation: nil, object: nil)
        for relationship in subjectRelationships
        {
            try universe.deleteRelationship(relationship: relationship)
        }

        let objectRelationships = try universe.query(subject: nil, relation: nil, object: self.identifier)
        for relationship in objectRelationships
        {
            try universe.deleteRelationship(relationship: relationship)
        }
    }

    public func exists() throws -> Bool
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        let other: T = try universe.load(identifier: self.identifier)
        return other == self.object
    }

    public func save() throws
    {
        guard let universe = self.universe else
        {
            throw ReferenceError.noUniverse
        }

        try universe.save(identifier: self.identifier, object: self.object)
    }
}

// Public error type
public enum ReferenceError: Error
{
    case noUniverse
}
