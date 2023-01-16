//
//  Relations.swift
//  Spacetime
//
//  Created by Dr. Brandon Wiley on 1/29/21.
//

import Datable
import Foundation

public enum Relation: Int, Codable
{
    // Once a relation has been added to the database, the number can't be changed or else it will cause problems.
    case contains = 0
    case authors = 1
}

extension Relation: Stringable
{
    public init(string: String)
    {
        switch string
        {
            case "contains":
                self = .contains
            default:
                self = .contains // FIXME
        }
    }

    public var string: String
    {
        switch self
        {
            case .contains:
                return "contains"

            case .authors:
                return "authors"
        }
    }
}

public struct Relationship: Codable
{
    public let subject: UInt64
    public let relation: Relation
    public let object: UInt64

    public init(subject: UInt64, relation: Relation, object: UInt64)
    {
        self.subject = subject
        self.relation = relation
        self.object = object
    }
}

extension Relationship: Equatable
{
    public static func == (lhs: Relationship, rhs: Relationship) -> Bool
    {
        return lhs.subject == rhs.subject && lhs.relation == rhs.relation && lhs.object == rhs.object
    }
}

extension Relationship: Hashable
{
}
