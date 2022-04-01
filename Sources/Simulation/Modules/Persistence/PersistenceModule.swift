//
//  PersistenceModule.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation
import Spacetime

public class PersistenceModule: Module
{
    static public let name = "persistence"

    let dataDatabase = DataDatabase.instance
    let relationshipDatabase = RelationshipDatabase.instance

    public func name() -> String
    {
        return PersistenceModule.name
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case let request as DataDeleteRequest:
                let result = self.dataDatabase.delete(identifier: request.dataId)
                let response = DataDeleteResponse(request.id, request.dataId, success: result)
                print(response.description)
                return response

            case let request as DataLoadRequest:
                do
                {
                    let result = try self.dataDatabase.getStatic(identifier: request.dataId)
                    let response = DataLoadResponse(request.id, request.dataId, success: true, data: result)
                    print(response.description)
                    return response
                }
                catch
                {
                    let response = DataLoadResponse(request.id, request.dataId, success: false, data: nil)
                    print(response.description)
                    return response
                }

            case let request as DataSaveRequest:
                do
                {
                    try self.dataDatabase.save(identifier: request.dataId, type: request.type, data: request.data)
                    let response = DataSaveResponse(request.id, request.dataId, success: true)
                    print(response.description)
                    return response
                }
                catch
                {
                    let response = DataSaveResponse(request.id, request.dataId, success: false)
                    print(response.description)
                    return response
                }

            case let request as RelationshipQueryRequest:
                let results = self.relationshipDatabase.query(subject: request.subject, relation: request.relation, object: request.object)
                let response = RelationshipQueryResponse(request.id, results)
                print(response.description)
                return response


            case let request as RelationshipRemoveRequest:
                do
                {
                    try self.relationshipDatabase.remove(relationship: request.relationship)
                    let response = RelationshipRemoveResponse(effect.id, true)
                    print(response.description)
                    return response

                }
                catch
                {
                    let response = RelationshipRemoveResponse(effect.id, false)
                    print(response.description)
                    return response

                }

            case let request as RelationshipSaveRequest:
                do
                {
                    try self.relationshipDatabase.save(relationship: request.relationship)
                    let response = RelationshipRemoveResponse(effect.id, true)
                    print(response.description)
                    return response

                }
                catch
                {
                    let response = RelationshipRemoveResponse(effect.id, false)
                    print(response.description)
                    return response

                }

            default:
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
