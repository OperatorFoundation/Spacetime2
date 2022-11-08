//
//  Universe.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Chord
import Spacetime
import SwiftQueue

open class Universe
{
    let logger: Logger
    let effects: BlockingQueue<Effect>
    let events: BlockingQueue<Event>
    var channels: [UUID: BlockingQueue<Event>] = [:]
    var database: CodableDatabase? = nil

    public init(effects: BlockingQueue<Effect>, events: BlockingQueue<Event>, logger: Logger? = nil)
    {
        self.effects = effects
        self.events = events
        
        if let providedLogger = logger
        {
            self.logger = providedLogger
        }
        else
        {
            #if os(macOS) || os(iOS)
            self.logger = Logger(subsystem: "org.OperatorFoundation.SpacetimeLogger", category: "Universe")
            #else
            self.logger = Logger(label: "org.OperatorFoundation.SpacetimeLogger")
            #endif
        }

        let queue = DispatchQueue(label: "distributeEvents")
        queue.async
        {
            self.distributeEvents()
        }
    }

    public func run() throws
    {
        try self.main()
    }

    open func main() throws
    {
    }

    public func processEffect(_ effect: Effect) -> Event
    {
        let channel = BlockingQueue<Event>()
        self.channels[effect.id] = channel

        self.effects.enqueue(element: effect)

        let result = channel.dequeue()

        return result
    }

    open func processEvent(_ event: Event)
    {
        return
    }

    func distributeEvents()
    {
        logger.log("🪐 Spacetime.Universe: distributeEvents called, beginning loop...")

        while true
        {
            let event = self.events.dequeue()
            
            #if os(macOS) || os(iOS)
            logger.log("🪐 Spacetime.Universe: distributeEvents dequed \(event.description, privacy: .public)")
            #else
            logger.debug("🪐 Spacetime.Universe: distributeEvents dequed \(event.description)")
            #endif

            
            if let id = event.effectId
            {
                #if os(macOS) || os(iOS)
                logger.log("🪐 Spacetime.Universe: distributeEvents adding event to channel queue \(event.description, privacy: .public)")
                #else
                logger.debug("🪐 Spacetime.Universe: distributeEvents adding event to channel queue \(event.description)")
                #endif

                guard let channel = self.channels[id] else
                {
                    #if os(macOS) || os(iOS)
                    logger.log("🪐 Spacetime.Universe: Unknown channel id \(id)")
                    #else
                    logger.debug("🪐 Spacetime.Universe: Unknown channel id \(id)")
                    #endif
                    continue
                }

                channel.enqueue(element: event)

                self.channels.removeValue(forKey: id)
            }
            else
            {
                #if os(macOS) || os(iOS)
                logger.log("🪐 Spacetime.Universe: distributeEvents calling process(event) \(event.description, privacy: .public)")
                #else
                logger.debug("🪐 Spacetime.Universe: distributeEvents calling process(event) \(event.description)")
                #endif

                self.processEvent(event)
                #if os(macOS) || os(iOS)
                logger.log("🪐 Spacetime.Universe: distributeEvents finished calling process(event) \(event.description, privacy: .public)")
                #else
                logger.debug("🪐 Spacetime.Universe: distributeEvents finished calling process(event) \(event.description)")
                #endif
            }
            
            #if os(macOS) || os(iOS)
            logger.log("🪐 Spacetime.Universe: distributeEvents finished handling \(event.description, privacy: .public)")
            #else
            logger.debug("🪐 Spacetime.Universe: distributeEvents finished handling \(event.description)")
            #endif
        }
    }
}
