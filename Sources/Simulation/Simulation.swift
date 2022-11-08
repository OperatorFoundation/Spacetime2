//
//  Simulation.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
#if os(macOS) || os(iOS)
import os.log
#endif

import Chord
import Spacetime
import Transmission

public class Simulation
{
    let logger: Logger
    let capabilities: Capabilities
    public let effects: BlockingQueue<Effect> = BlockingQueue<Effect>(name: "Spacetime.effects")
    public let events: BlockingQueue<Event> = BlockingQueue<Event>(name: "Spacetime.events")
    let queue = DispatchQueue(label: "Simulation.handleEvents")
    var userModules: [String: Module] = [:]

    public init(capabilities: Capabilities, userModules: [Module]? = nil, logger: Logger? = nil)
    {
        if let newLog = logger
        {
            self.logger = newLog
        }
        else
        {
            self.logger = Logger(subsystem: "org.OperatorFoundation.SpacetimeLogger", category: "Simulation")
        }
        
        self.capabilities = capabilities

        if let userModules = userModules
        {
            for module in userModules
            {
                self.userModules[module.name()] = module
            }
        }

        self.queue.async
        {
            self.handleEffects()
        }
    }

    func handleEffects()
    {
        while true
        {
            let effect = self.effects.dequeue()

            switch effect
            {
                case is Display:
                    skip()

                default:
                    print(effect.description)
            }

            var handled = false

            for (name, module) in BuiltinModules.modules
            {
                if effect.module == name && self.capabilities.hasCapability(effect.module)
                {
                    handled = true

                    if let response = module.handleEffect(effect, self.events)
                    {
                        switch response
                        {
                            case is Affected:
                                skip()

                            default:
                                print(response.description)
                        }

                        events.enqueue(element: response)
                    }

                    break
                }
            }

            if handled
            {
                continue
            }

            for (name, module) in self.userModules
            {
                handled = true

                if effect.module == name && self.capabilities.hasCapability(effect.module)
                {
                    if let response = module.handleEffect(effect, self.events)
                    {
                        logger.log("🪐 Spacetime: Simulation handleEffects() enqueing event: \(response.description, privacy: .public)")
                        events.enqueue(element: response)
                        logger.log("🪐 Spacetime: Simulation handleEffects() enqued event: \(response.description, privacy: .public) ")
                    }

                    break
                }
            }

            if handled
            {
                continue
            }

            let response = Failure(effect.id)
            print(response.description)
            events.enqueue(element: response)
            continue
        }
    }

    func skip()
    {
        return
    }
}
