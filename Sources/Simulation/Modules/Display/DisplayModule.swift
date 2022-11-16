//
//  DisplayModule.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation

#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Spacetime

public class DisplayModule: Module
{
    public var logger: Logger?
    
    public func setLogger(logger: Logger?)
    {
        self.logger = logger
    }
    
    static public let name = "display"

    public func name() -> String
    {
        return DisplayModule.name
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case let display as Display:
                print(display.string)
                return Affected(effect.id)
                
            default:
                return Failure(effect.id)
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }
}
