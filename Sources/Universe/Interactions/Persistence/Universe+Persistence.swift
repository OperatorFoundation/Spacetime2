//
//  Universe+Persistence.swift
//
//
//  Created by Clockwork on Jan 12, 2023.
//

import Foundation

import Spacetime

extension Universe
{
    public func allocateIdentifier() throws -> UInt64
    {
        let request = PersistenceAllocateidentifierRequest()
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceAllocateidentifierResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func exists(identifier: UInt64) throws -> Bool
    {
        let request = PersistenceExistsRequest(identifier: identifier)
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceExistsResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func loadData(identifier: UInt64) throws -> Data
    {
        let request = PersistenceLoaddataRequest(identifier: identifier)
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceLoaddataResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func saveData(identifier: UInt64, type: String, data: Data) throws
    {
        let request = PersistenceSavedataRequest(identifier: identifier, type: type, data: data)
        let result = self.processEffect(request)

        switch result
        {
            case is PersistenceSavedataResponse:
                return

            default:
                throw PersistenceError.failure
        }
    }

    public func deleteData(identifier: UInt64) throws -> Bool
    {
        let request = PersistenceDeletedataRequest(identifier: identifier)
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceDeletedataResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func count(type: String) throws -> Int
    {
        let request = PersistenceCountRequest(type: type)
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceCountResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func load(type: String, offset: Int) throws -> UInt64
    {
        let request = PersistenceLoadRequest(type: type, offset: offset)
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceLoadResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func query(subject: UInt64?, relation: Relation?, object: UInt64?) throws -> [Relationship]
    {
        let request = PersistenceQueryRequest(subject: subject, relation: relation, object: object)
        let result = self.processEffect(request)

        switch result
        {
            case let response as PersistenceQueryResponse:
                return response.result

            default:
                throw PersistenceError.failure
        }
    }

    public func saveRelationship(relationship: Relationship) throws
    {
        let request = PersistenceSaverelationshipRequest(relationship: relationship)
        let result = self.processEffect(request)

        switch result
        {
            case is PersistenceSaverelationshipResponse:
                return

            default:
                throw PersistenceError.failure
        }
    }

    public func deleteRelationship(relationship: Relationship) throws
    {
        let request = PersistenceDeleterelationshipRequest(relationship: relationship)
        let result = self.processEffect(request)

        switch result
        {
            case is PersistenceDeleterelationshipResponse:
                return

            default:
                throw PersistenceError.failure
        }
    }
}

public enum PersistenceError: Error
{
    case failure
}
