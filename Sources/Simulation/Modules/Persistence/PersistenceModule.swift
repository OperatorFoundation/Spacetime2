//
//  PersistenceModule.swift
//
//
//  Created by Clockwork on Jan 12, 2023.
//

import Foundation
#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Chord
import Spacetime

public class PersistenceModule: Module
{
    static public let name = "Persistence"

    public var logger: Logger?

    let handler: Persistence

    public init()
    {
        self.handler = try! Persistence(root: "spacetime")
    }

    public func name() -> String
    {
        return Self.name
    }

    public func setLogger(logger: Logger?)
    {
        self.logger = logger
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        do
        {
            switch effect
            {
                case let request as PersistenceAllocateidentifierRequest:
                    let result = try self.handler.allocateIdentifier()
                    let response = PersistenceAllocateidentifierResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceExistsRequest:
                    let result = self.handler.exists(identifier: request.identifier)
                    let response = PersistenceExistsResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceLoaddataRequest:
                    let result = try self.handler.loadData(identifier: request.identifier)
                    let response = PersistenceLoaddataResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceSavedataRequest:
                    try self.handler.saveData(identifier: request.identifier, type: request.type, data: request.data)
                    let response = PersistenceSavedataResponse(request.id)
                    print(response.description)
                    return response
                case let request as PersistenceDeletedataRequest:
                    let result = self.handler.deleteData(identifier: request.identifier)
                    let response = PersistenceDeletedataResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceCountRequest:
                    let result = try self.handler.count(type: request.type)
                    let response = PersistenceCountResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceLoadRequest:
                    let result = try self.handler.load(type: request.type, offset: request.offset)
                    let response = PersistenceLoadResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceAppendRequest:
                    try self.handler.append(type: request.type, identifier: request.identifier)
                    let response = PersistenceAppendResponse(request.id)
                    print(response.description)
                    return response
                case let request as PersistenceQueryRequest:
                    let result = self.handler.query(subject: request.subject, relation: request.relation, object: request.object)
                    let response = PersistenceQueryResponse(request.id, result)
                    print(response.description)
                    return response
                case let request as PersistenceSaverelationshipRequest:
                    try self.handler.saveRelationship(relationship: request.relationship)
                    let response = PersistenceSaverelationshipResponse(request.id)
                    print(response.description)
                    return response
                case let request as PersistenceDeleterelationshipRequest:
                    try self.handler.deleteRelationship(relationship: request.relationship)
                    let response = PersistenceDeleterelationshipResponse(request.id)
                    print(response.description)
                    return response
                default:
                    let response = Failure(effect.id)
                    print(response.description)
                    return response
            }
        }
        catch
        {
            print(error)
            let response = Failure(effect.id)
            print(response.description)
            return response
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }
}
