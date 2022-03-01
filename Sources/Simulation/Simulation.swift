//
//  Simulation.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import SwiftQueue
import Spacetime
import Chord
import Transmission

public class Simulation
{
    let capabilities: Capabilities
    public let effects: BlockingQueue<Effect> = BlockingQueue<Effect>()
    public let events: BlockingQueue<Event> = BlockingQueue<Event>()
    public var state: SimulationState = SimulationState()

    public init(capabilities: Capabilities)
    {
        self.capabilities = capabilities

        Task
        {
            self.handleEvents()
        }
    }

    func handleEvents()
    {
        while true
        {
            print("handleEvent getting event")
            let effect = effects.dequeue()
            print("handleEvent got event \(effect)")

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
                    let failure = Failure()
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
                    let affected = Affected()
                    events.enqueue(element: affected)
                default:
                    let failure = Failure()
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure()
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
                    let uuid = UUID()
                    let connection = TransmissionConnection(host: request.address, port: request.port, type: request.type, logger: nil)
                    self.state.connections[uuid] = connection
                    let response = ConnectResponse(uuid)
                    events.enqueue(element: response)

                default:
                    let failure = Failure()
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure()
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

                    let acceptUuid = UUID()
                    let accepted = listener.accept()
                    self.state.connections[acceptUuid] = accepted
                    let response = AcceptResponse(acceptUuid)
                    events.enqueue(element: response)

                case let request as ListenRequest:
                    let uuid = UUID()
                    let listener = TransmissionListener(port: request.port, logger: nil)
                    self.state.listeners[uuid] = listener
                    let response = ListenResponse(uuid)
                    events.enqueue(element: response)

                default:
                    let failure = Failure()
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure()
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

                    switch request.style
                    {
                        case .exactSize(let size):
                            guard let result = connection.read(size: size) else
                            {
                                let failure = Failure(request.id)
                                events.enqueue(element: failure)
                                return
                            }

                            let response = NetworkReadResponse(request.id, result)
                            events.enqueue(element: response)
                        case .maxSize(let size):
                            guard let result = connection.read(maxSize: size) else
                            {
                                let failure = Failure(request.id)
                                events.enqueue(element: failure)
                                return
                            }

                            let response = NetworkReadResponse(request.id, result)
                            events.enqueue(element: response)
                        case .lengthPrefixSizeInBits(let prefixSize):
                            guard let result = connection.readWithLengthPrefix(prefixSizeInBits: prefixSize) else
                            {
                                let failure = Failure(request.id)
                                events.enqueue(element: failure)
                                return
                            }

                            let response = NetworkReadResponse(request.id, result)
                            events.enqueue(element: response)
                    }

                case let request as NetworkWriteRequest:
                    let uuid = request.socketId
                    guard let connection = self.state.connections[uuid] else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    if let prefixSize = request.lengthPrefixSizeInBits
                    {
                        guard connection.writeWithLengthPrefix(data: request.data, prefixSizeInBits: prefixSize) else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            return
                        }

                        let response = Affected(request.id)
                        events.enqueue(element: response)
                    }
                    else
                    {
                        guard connection.write(data: request.data) else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            return
                        }

                        let response = Affected(request.id)
                        events.enqueue(element: response)
                    }

                default:
                    let failure = Failure()
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure()
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
                    let failure = Failure()
                    events.enqueue(element: failure)
            }
        }
        else
        {
            let failure = Failure()
            events.enqueue(element: failure)
        }
    }
}

public class SimulationState
{
    public var listeners: [UUID: TransmissionListener] = [:]
    public var connections: [UUID: Connection] = [:]

    public init()
    {
    }
}
