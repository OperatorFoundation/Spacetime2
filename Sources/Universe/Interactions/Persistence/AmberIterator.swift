//
//  AmberIterator.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/12/23.
//

import Foundation

public class AmberIterator<R, T>: IteratorProtocol where R: Reference<T>, T: Codable
{
    public typealias Element = Reference<T>

    let type: String
    let universe: Universe

    var running = true
    var index: Int = 0

    public init(type: String, universe: Universe)
    {
        self.type = type
        self.universe = universe
    }

    public func next() -> Element?
    {
        if running
        {
            return nil
        }

        do
        {
            let identifier = try self.universe.load(type: self.type, offset: self.index)
            let result: Reference<T> = try self.universe.load(identifier: identifier)
            self.index = self.index + 1
            return result
        }
        catch
        {
            self.running = false
            return nil
        }
    }
}
