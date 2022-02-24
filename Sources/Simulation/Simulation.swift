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
    public let effects: BlockingQueue<Effect> = BlockingQueue<Effect>()
    public let events: BlockingQueue<Event> = BlockingQueue<Event>()
    public var state: SimulationState = SimulationState()

    public init()
    {
        Task
        {
            while true
            {
                let effect = effects.dequeue()
                switch effect
                {
                    case let display as Display:
                        print(display.string)
                        let affected = Affected()
                        events.enqueue(element: affected)
                    case is RandomRequest:
                        let result = UInt64.random(in: 0..<UInt64.max)
                        let response = RandomResponse(effect.id, result)
                        events.enqueue(element: response)
                    case let request as ListenRequest:
                        let uuid = UUID()
                        let listener = TransmissionListener(port: request.port, logger: nil)
                        self.state.listeners[uuid] = listener
                        let response = ListenResponse(uuid)
                        events.enqueue(element: response)
                    case let request as ConnectRequest:
                        let uuid = UUID()
                        let connection = TransmissionConnection(host: request.address, port: request.port, logger: nil)
                        self.state.connections[uuid] = connection
                        let response = ConnectResponse(uuid)
                        events.enqueue(element: response)
                    case let request as AcceptRequest:
                        let listenUuid = request.socketId
                        guard let listener = self.state.listeners[listenUuid] else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            continue
                        }

                        let acceptUuid = UUID()
                        let accepted = listener.accept()
                        self.state.connections[acceptUuid] = accepted
                        let response = AcceptResponse(acceptUuid)
                        events.enqueue(element: response)
                    case let request as NetworkReadRequest:
                        let uuid = request.socketId
                        guard let connection = self.state.connections[uuid] else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            continue
                        }

                        guard let result = connection.read(size: Int(request.length)) else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            continue
                        }

                        let response = NetworkReadResponse(request.id, result)
                        events.enqueue(element: response)
                    case let request as NetworkWriteRequest:
                        let uuid = request.socketId
                        guard let connection = self.state.connections[uuid] else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            continue
                        }

                        guard connection.write(data: request.data) else
                        {
                            let failure = Failure(request.id)
                            events.enqueue(element: failure)
                            continue
                        }

                        let response = Affected(request.id)
                        events.enqueue(element: response)
                    default:
                        let failure = Failure()
                        events.enqueue(element: failure)
                }
            }
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
