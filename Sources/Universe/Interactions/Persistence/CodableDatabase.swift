//
//  CodableDatabase.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation
import Spacetime

public class CodableDatabase
{
    let universe: Universe

    public init(_ universe: Universe)
    {
        self.universe = universe
    }

    public func load<T>(identifier: UInt64) throws -> T where T: Codable
    {
        let request = DataLoadRequest(dataId: identifier)
        let result = self.universe.processEffect(request)

        switch result
        {
            case let response as DataLoadResponse:
                guard response.success else
                {
                    throw CodableDatabaseError.failure
                }

                guard let data = response.data else
                {
                    throw CodableDatabaseError.failure
                }

                let decoder = JSONDecoder()
                let codable: T = try decoder.decode(T.self, from: data)

                return codable
            default:
                throw CodableDatabaseError.badResponse(result)
        }
    }

    public func save<T>(identifier: UInt64, codable: T) throws where T: Codable
    {
        let encoder = JSONEncoder()
        let data = try encoder.encode(codable)

        let type = "\(type(of: codable))"
        let request = DataSaveRequest(dataId: identifier, type: type, data: data)
        let result = self.universe.processEffect(request)

        switch result
        {
            case let response as DataSaveResponse:
                guard response.success else
                {
                    throw CodableDatabaseError.failure
                }

                return

            default:
                throw CodableDatabaseError.badResponse(result)
        }
    }

    public func delete(identifier: UInt64) throws
    {
        let request = DataDeleteRequest(dataId: identifier)
        let result = self.universe.processEffect(request)

        switch result
        {
            case let response as DataDeleteResponse:
                guard response.success else
                {
                    throw CodableDatabaseError.failure
                }

                return

            default:
                throw CodableDatabaseError.badResponse(result)
        }
    }
}

extension Universe
{
    public func save<T>(identifier: UInt64, codable: T) throws where T: Codable
    {
        let db: CodableDatabase
        if let database = self.database
        {
            db = database
        }
        else
        {
            db = CodableDatabase(self)
            self.database = db
        }

        try db.save(identifier: identifier, codable: codable)
    }

    public func load<T>(identifier: UInt64) throws -> T where T: Codable
    {
        let db: CodableDatabase
        if let database = self.database
        {
            db = database
        }
        else
        {
            db = CodableDatabase(self)
            self.database = db
        }

        return try db.load(identifier: identifier)
    }

    public func delete(identifier: UInt64) throws
    {
        let db: CodableDatabase
        if let database = self.database
        {
            db = database
        }
        else
        {
            db = CodableDatabase(self)
            self.database = db
        }

        return try db.delete(identifier: identifier)
    }
}


public enum CodableDatabaseError: Error
{
    case failure
    case badResponse(Event)
}
