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

        self.effects.enqueue(element: effect)

        let result = channel.dequeue()

        return result
    }

    func distributeEvents()
    {
        while true
        {
            let event = self.events.dequeue()
            guard let id = event.effectId else
            {
                print("Event without an id \(event)")
                continue
            }

            guard let channel = self.channels[id] else
            {
                print("Unknown channel id \(id)")
                continue
            }

            channel.enqueue(element: event)
            print(event.description)

            self.channels.removeValue(forKey: id)
        }
    }
}
