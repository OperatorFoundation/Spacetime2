//
//  DataDatabase.swift
//  Spacetime
//
//  Created by Dr. Brandon Wiley on 10/11/21.
//

import Foundation

import Amber
import Datable
import ParchmentFile

extension Universe
{
    public func load<T>(identifier: UInt64) throws -> T
    {
        let data = try self.loadData(identifier: identifier)
        let types = Types.type(String(describing: T.self))
        let anyResult = try Amber.load(data)
        guard let result = anyResult as? T else
        {
            throw AmberDatabaseError.wrongType
        }

        return result
    }

    // FIXME - update index
    public func save<T>(identifier: UInt64, object: T) throws
    {
        let data = try Amber.save(object)
        let typeName = String(describing: T.self)
        try self.saveData(identifier: identifier, type: typeName, data: data)
    }

    // FIXME - update index
    public func delete(identifier: UInt64) throws -> Bool
    {
        return try self.deleteData(identifier: identifier)
    }
}

public class IndexIterator<T>: IteratorProtocol where T: Persistable
{
    public typealias Element = T

    let database: Universe
    let iterator: ParchmentIterator

    var running: Bool = true

    public init(database: Universe, iterator: ParchmentIterator)
    {
        self.database = database
        self.iterator = iterator
    }

    public func next() -> Element?
    {
        guard running else
        {
            return nil
        }

        guard let index = self.iterator.next() else
        {
            self.running = false
            return nil
        }

        do
        {
            return try self.database.load(identifier: index)
        }
        catch
        {
            running = false
            return nil
        }
    }
}

public enum AmberDatabaseError: Error
{
    case wrongType
}
