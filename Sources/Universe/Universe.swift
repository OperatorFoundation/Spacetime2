//
//  Universe.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import SwiftQueue
import Spacetime
import Chord

open class Universe
{
    let effects: BlockingQueue<Effect>
    let events: BlockingQueue<Event>

    public init(effects: BlockingQueue<Effect>, events: BlockingQueue<Event>)
    {
        self.effects = effects
        self.events = events
    }

    public func run() async throws
    {
        Task
        {
            try self.main()
        }
    }

    open func main() throws
    {
    }
}
