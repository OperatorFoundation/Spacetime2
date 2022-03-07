//
//  Simulation.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Chord
import Foundation
import Spacetime
import Transmission

public class Simulation
{
    let capabilities: Capabilities
    public let effects: BlockingQueue<Effect> = BlockingQueue<Effect>(name: "Spacetime.effects")
    public let events: BlockingQueue<Event> = BlockingQueue<Event>(name: "Spacetime.events")
    public var state: SimulationState = SimulationState()
    let queue = DispatchQueue(label: "Simulation.handleEvents")

    public init(capabilities: Capabilities)
    {
        self.capabilities = capabilities

        self.queue.async
        {
            self.handleEvents()
        }
    }

    func handleEvents()
    {
        while true
        {
            let effect = effects.dequeue()
            print(effect.description)

            switch effect
            {
                // display
                case is Display:
                    handleDisplay(effect)

                // networkConnect
                case is ConnectRequest:
                    handleNetworkConnect(effect)

                // networkListen
                case is AcceptRequest:
                    handleNetworkListen(effect)
                case is ListenRequest:
                    handleNetworkListen(effect)

                // networkConnect or networkListen
                case is NetworkReadRequest:
                    handleNetwork(effect)
                case is NetworkWriteRequest:
                    handleNetwork(effect)

                // random
                case is RandomRequest:
                    handleRandom(effect)

                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
    }

    func handleDisplay(_ effect: Effect)
    {
        if self.capabilities.display
        {
            switch effect
            {
                case let display as Display:
                    print(display.string)
                    let affected = Affected(effect.id)
                    events.enqueue(element: affected)
                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure(effect.id)
            events.enqueue(element: failure)
        }
    }

    func handleNetworkConnect(_ effect: Effect)
    {
        if self.capabilities.networkConnect
        {
            switch effect
            {
                case let request as ConnectRequest:
                    guard let uuid = self.connect(host: request.address, port: request.port, type: request.type) else
                    {
                        return
                    }

                    let response = ConnectResponse(effect.id, uuid)
                    events.enqueue(element: response)

                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure(effect.id)
            events.enqueue(element: failure)
        }
    }

    func handleNetworkListen(_ effect: Effect)
    {
        if self.capabilities.networkListen
        {
            switch effect
            {
                case let request as AcceptRequest:
                    let listenUuid = request.socketId
                    guard let listener = self.state.listeners[listenUuid] else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    listener.accept(request: request, state: self.state, channel: self.events)

                case let request as ListenRequest:
                    guard let uuid = listen(port: request.port) else
                    {
                        let response = Failure(effect.id)
                        events.enqueue(element: response)
                        return
                    }

                    let response = ListenResponse(effect.id, uuid)
                    events.enqueue(element: response)

                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure(effect.id)
            events.enqueue(element: failure)
        }
    }

    func handleNetwork(_ effect: Effect)
    {
        if self.capabilities.networkConnect || self.capabilities.networkListen
        {
            switch effect
            {
                case let request as NetworkReadRequest:
                    let uuid = request.socketId
                    guard let connection = self.state.connections[uuid] else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    connection.read(request: request, channel: self.events)

                case let request as NetworkWriteRequest:
                    let uuid = request.socketId
                    guard let connection = self.state.connections[uuid] else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    connection.write(request: request, channel: self.events)

                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure(effect.id)
            events.enqueue(element: failure)
        }
    }

    func handleRandom(_ effect: Effect)
    {
        if self.capabilities.random
        {
            switch effect
            {
                case is RandomRequest:
                    let result = UInt64.random(in: 0..<UInt64.max)
                    let response = RandomResponse(effect.id, result)
                    events.enqueue(element: response)

                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure(effect.id)
            events.enqueue(element: failure)
        }
    }

    func connect(host: String, port: Int, type: ConnectionType) -> UUID?
    {
        let uuid = UUID()
        guard let networkConnection = TransmissionConnection(host: host, port: port, type: type, logger: nil) else
        {
            return nil
        }

        let connection = SimulationConnection(networkConnection)
        self.state.connections[uuid] = connection

        return uuid
    }

    func listen(port: Int) -> UUID?
    {
        let uuid = UUID()
        guard let networkListener = TransmissionListener(port: port, logger: nil) else
        {
            return nil
        }

        let listener = SimulationListener(networkListener)
        self.state.listeners[uuid] = listener

        return uuid
    }
}

public class SimulationState
{
    public var listeners: [UUID: SimulationListener] = [:]
    public var connections: [UUID: SimulationConnection] = [:]

    public init()
    {
    }
}
