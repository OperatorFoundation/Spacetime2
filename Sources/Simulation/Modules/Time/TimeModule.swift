//
//  TimeModule.swift
//
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Chord
import Foundation
import Spacetime

public class TimeModule: Module
{
    static public let name = "time"
    public var logger: Logger?

    public func name() -> String
    {
        return TimeModule.name
    }
    
    public func setLogger(logger: Logger?)
    {
        self.logger = logger
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
