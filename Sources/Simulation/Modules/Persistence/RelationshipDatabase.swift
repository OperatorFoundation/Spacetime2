//
//  RelationshipDatabase.swift
//  Spacetime
//
//  Created by Dr. Brandon Wiley on 2/20/22.
//

import Datable
import Foundation
import Spacetime

public class RelationshipDatabase
{
    static public let instance: RelationshipDatabase = RelationshipDatabase(root: "relationshipDatabase")

    let root: String
    let path: String

    public init(root: String)
    {
        self.root = root
        self.path = "\(self.root)/relationships"
        
        if !FileManager.default.fileExists(atPath: self.root)
        {
            do
            {
                try FileManager.default.createDirectory(atPath: self.root, withIntermediateDirectories: true)
            }
            catch let dirError
            {
                print("Failed to create a directory at \(self.root). Error: \(dirError)")
            }
        }

        if !FileManager.default.fileExists(atPath: self.path)
        {
            do
            {
                try FileManager.default.createDirectory(atPath: self.path, withIntermediateDirectories: true)
            }
            catch let dirError
            {
                print("Failed to create a directory at \(self.path). Error: \(dirError)")
            }
        }
    }

    public func query(subject: UInt64?, relation: Relation?, object: UInt64?) -> [Relationship]
    {
        let filename = "\(string(subject)).\(string(relation)).\(string(object))"
        let url = URL(fileURLWithPath: "\(self.path)/\(filename)")

        do
        {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let result = try decoder.decode([Relationship].self, from: data)
            return result
        }
        catch
        {
            return []
        }
    }

    public func save(relationship: Relationship) throws
    {
        try save(subject: relationship.subject, relation: relationship.relation, object: relationship.object, relationship: relationship)
        try save(subject: nil, relation: relationship.relation, object: relationship.object, relationship: relationship)
        try save(subject: relationship.subject, relation: nil, object: relationship.object, relationship: relationship)
        try save(subject: relationship.subject, relation: relationship.relation, object: nil, relationship: relationship)
        try save(subject: nil, relation: nil, object: relationship.object, relationship: relationship)
        try save(subject: nil, relation: relationship.relation, object: nil, relationship: relationship)
        try save(subject: relationship.subject, relation: nil, object: nil, relationship: relationship)
        try save(subject: nil, relation: nil, object: nil, relationship: relationship)
    }

    public func remove(relationship: Relationship) throws
    {
        try remove(subject: relationship.subject, relation: relationship.relation, object: relationship.object, relationship: relationship)
        try remove(subject: nil, relation: relationship.relation, object: relationship.object, relationship: relationship)
        try remove(subject: relationship.subject, relation: nil, object: relationship.object, relationship: relationship)
        try remove(subject: relationship.subject, relation: relationship.relation, object: nil, relationship: relationship)
        try remove(subject: nil, relation: nil, object: relationship.object, relationship: relationship)
        try remove(subject: nil, relation: relationship.relation, object: nil, relationship: relationship)
        try remove(subject: relationship.subject, relation: nil, object: nil, relationship: relationship)
        try remove(subject: nil, relation: nil, object: nil, relationship: relationship)
    }

    func save(subject: UInt64?, relation: Relation?, object: UInt64?, relationship: Relationship) throws
    {
        var relationships = query(subject: subject, relation: relation, object: object)
        if relationships.contains(relationship)
        {
            return
        }

        relationships.append(relationship)

        let filename = "\(string(subject)).\(string(relation)).\(string(object))"
        let url = URL(fileURLWithPath: "\(self.path)/\(filename)")
        let encoder = JSONEncoder()
        let data = try encoder.encode(relationships)
        try data.write(to: url)
    }

    func remove(subject: UInt64?, relation: Relation?, object: UInt64?, relationship: Relationship) throws
    {
        var relationships = query(subject: subject, relation: relation, object: object)
        let oldCount = relationships.count
        relationships.removeAll {$0 == relationship}
        guard relationships.count < oldCount else {return}

        let filename = "\(string(subject)).\(string(relation)).\(string(object))"
        let url = URL(fileURLWithPath: "\(self.path)/\(filename)")
        let encoder = JSONEncoder()
        let data = try encoder.encode(relationships)
        try data.write(to: url)
    }

    func string<T>(_ x: T?) -> String where T: Stringable
    {
        if let x = x
        {
            return x.string
        }
        else
        {
            return "_"
        }
    }
}
