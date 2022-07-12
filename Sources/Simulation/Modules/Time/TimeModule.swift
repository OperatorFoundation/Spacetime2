//
//  TimeModule.swift
//
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation
import Spacetime

public class TimeModule: Module
{
    static public let name = "time"

    public func name() -> String
    {
        return TimeModule.name
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case is DateRequest:
                let result = Date()
                return DateResponse(effect.id, result)

            default:
                return Failure(effect.id)
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }
}
