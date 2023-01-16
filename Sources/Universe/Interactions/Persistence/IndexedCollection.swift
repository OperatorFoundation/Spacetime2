//
//  IndexedCollection.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/12/23.
//

import Foundation

import Amber

public struct IndexedCollection<T> where T: Codable
{
    public let name = "\(type(of: T.self))"
    public let universe: Universe

    public var startIndex: Int
    public var endIndex: Int

    public init(universe: Universe) throws
    {
        self.universe = universe
        self.startIndex = 0
        self.endIndex = try self.universe.count(type: self.name)
    }
}

extension IndexedCollection: Sequence
{
    public typealias Element = Reference<T>
    public typealias Iterator = AmberIterator<Reference<T>, T>

    public func makeIterator() -> Iterator
    {
        return AmberIterator<Reference<T>, T>(type: self.name, universe: self.universe)
    }
}

extension IndexedCollection: Collection
{
    public subscript(position: Int) -> Reference<T>
    {
        get
        {
            let index = try! self.universe.load(type: self.name, offset: position)
            return try! Reference(universe: self.universe, identifier: index)
        }
    }

    public func index(after i: Int) -> Int
    {
        return i + 1
    }
}

extension IndexedCollection: BidirectionalCollection
{
    public func index(before i: Int) -> Int
    {
        return i - 1
    }
}

extension IndexedCollection: RandomAccessCollection
{
}
