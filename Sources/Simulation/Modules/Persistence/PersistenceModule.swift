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
                return DataDeleteResponse(request.id, request.dataId, success: result)

            case let request as DataLoadRequest:
                do
                {
                    let result = try self.dataDatabase.getStatic(identifier: request.dataId)
                    return DataLoadResponse(request.id, request.dataId, success: true, data: result)
                }
                catch
                {
                    return DataLoadResponse(request.id, request.dataId, success: false, data: nil)
                }

            case let request as DataSaveRequest:
                do
                {
                    try self.dataDatabase.save(identifier: request.dataId, type: request.type, data: request.data)
                    return DataSaveResponse(request.id, request.dataId, success: true)
                }
                catch
                {
                    return DataSaveResponse(request.id, request.dataId, success: false)
                }

            case let request as RelationshipQueryRequest:
                let results = self.relationshipDatabase.query(subject: request.subject, relation: request.relation, object: request.object)
                return RelationshipQueryResponse(request.id, results)

            case let request as RelationshipRemoveRequest:
                do
                {
                    try self.relationshipDatabase.remove(relationship: request.relationship)
                    return RelationshipRemoveResponse(effect.id, true)
                }
                catch
                {
                    return RelationshipRemoveResponse(effect.id, false)
                }

            case let request as RelationshipSaveRequest:
                do
                {
                    try self.relationshipDatabase.save(relationship: request.relationship)
                    return RelationshipRemoveResponse(effect.id, true)
                }
                catch
                {
                    return RelationshipRemoveResponse(effect.id, false)
                }

            default:
                return Failure(effect.id)
        }
    }
}
