//
//  Universe.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Chord
import Foundation
import Spacetime
import SwiftQueue

open class Universe
{
    let effects: BlockingQueue<Effect>
    let events: BlockingQueue<Event>
    var channels: [UUID: BlockingQueue<Event>] = [:]

    public init(effects: BlockingQueue<Effect>, events: BlockingQueue<Event>)
    {
        self.effects = effects
        self.events = events

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

        print("added \(effect.id) to a blocking queue")
        
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
        while true
        {
            let event = self.events.dequeue()
            if let id = event.effectId
            {
                print("found an event with id: \(id)")
                guard let channel = self.channels[id] else
                {
                    print("Unknown channel id \(id)")
                    continue
                }

                print("enqueueing an event")
                channel.enqueue(element: event)

                self.channels.removeValue(forKey: id)
            }
            else
            {
                print("distributeEvents found an event without an id.  calling processEvent()")
                self.processEvent(event)
            }
        }
    }
}
