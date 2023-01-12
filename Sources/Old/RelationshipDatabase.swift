//
//  RelationshipDatabase.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation
import Spacetime

public class RelationshipDatabase
{
    let universe: Universe

    public init(_ universe: Universe)
    {
        self.universe = universe
    }

    public func query(subject: UInt64?, relation: Relation?, object: UInt64?) throws -> [Relationship]
    {
        let request = RelationshipQueryRequest(subject: subject, relation: relation, object: object)
        let result = self.universe.processEffect(request)

        switch result
        {
            case let response as RelationshipQueryResponse:
                return response.results
            default:
                throw CodableDatabaseError.badResponse(result)
        }
    }

    public func save(relationship: Relationship) throws
    {
        let request = RelationshipSaveRequest(relationship)
        let result = self.universe.processEffect(request)

        switch result
        {
            case let response as RelationshipSaveResponse:
                guard response.success else
                {
                    throw RelationshipDatabaseError.failure
                }

                return

            default:
                throw RelationshipDatabaseError.badResponse(result)
        }
    }

    public func remove(relationship: Relationship) throws
    {
        let request = RelationshipRemoveRequest(relationship)
        let result = self.universe.processEffect(request)

        switch result
        {
            case let response as RelationshipRemoveResponse:
                guard response.success else
                {
                    throw RelationshipDatabaseError.failure
                }

                return

            default:
                throw RelationshipDatabaseError.badResponse(result)
        }
    }
}

public enum RelationshipDatabaseError: Error
{
    case failure
    case badResponse(Event)
}

