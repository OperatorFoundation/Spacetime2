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

public class Universe<State> where State: Stateful
{
    var state: State
    let effects: BlockingQueue<Effect>
    let events: BlockingQueue<Event>

    public init(effects: BlockingQueue<Effect>, events: BlockingQueue<Event>)
    {
        self.state = State()

        self.effects = effects
        self.events = events
    }

    public func run() throws
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

public protocol Stateful
{
    init()
}

extension Int: Stateful
{
    public init()
    {
        self = 0
        return
    }
}
