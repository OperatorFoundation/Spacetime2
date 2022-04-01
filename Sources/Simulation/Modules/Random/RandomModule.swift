//
//  RandomModule.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation
import Spacetime

public class RandomModule: Module
{
    static public let name = "random"

    public func name() -> String
    {
        return RandomModule.name
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case is RandomRequest:
                let result = UInt64.random(in: 0..<UInt64.max)
                return RandomResponse(effect.id, result)

            default:
                return Failure(effect.id)
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }
}
