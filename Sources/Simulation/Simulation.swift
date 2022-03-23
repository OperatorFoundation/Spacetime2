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
    let dataDatabase = DataDatabase.instance
    let relationshipDatabase = RelationshipDatabase.instance

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
                case is NetworkCloseRequest:
                    handleNetwork(effect)

                // random
                case is RandomRequest:
                    handleRandom(effect)

                case is DataDeleteRequest:
                    handlePersistence(effect)
                case is DataLoadRequest:
                    handlePersistence(effect)
                case is DataSaveRequest:
                    handlePersistence(effect)
                case is RelationshipQueryRequest:
                    handlePersistence(effect)
                case is RelationshipRemoveRequest:
                    handlePersistence(effect)
                case is RelationshipSaveRequest:
                    handlePersistence(effect)

                default:
                    let failure = Failure(effect.id)
                    events.enqueue(element: failure)
            }
        }
    }

    func handlePersistence(_ effect: Effect)
    {
        if self.capabilities.persistence
        {
            switch effect
            {
                case let request as DataDeleteRequest:
                    let result = self.dataDatabase.delete(identifier: request.dataId)
                    let response = DataDeleteResponse(request.id, request.dataId, success: result)
                    events.enqueue(element: response)

                case let request as DataLoadRequest:
                    do
                    {
                        let result = try self.dataDatabase.getStatic(identifier: request.dataId)
                        let response = DataLoadResponse(request.id, request.dataId, success: true, data: result)
                        events.enqueue(element: response)
                    }
                    catch
                    {
                        let response = DataLoadResponse(request.id, request.dataId, success: false, data: nil)
                        events.enqueue(element: response)
                    }

                case let request as DataSaveRequest:
                    do
                    {
                        try self.dataDatabase.save(identifier: request.dataId, type: request.type, data: request.data)
                        let response = DataSaveResponse(request.id, request.dataId, success: true)
                        events.enqueue(element: response)
                    }
                    catch
                    {
                        let response = DataSaveResponse(request.id, request.dataId, success: false)
                        events.enqueue(element: response)
                    }

                case let request as RelationshipQueryRequest:
                    let results = self.relationshipDatabase.query(subject: request.subject, relation: request.relation, object: request.object)
                    let response = RelationshipQueryResponse(request.id, results)
                    events.enqueue(element: response)

                case let request as RelationshipRemoveRequest:
                    do
                    {
                        try self.relationshipDatabase.remove(relationship: request.relationship)
                        let result = RelationshipRemoveResponse(effect.id, true)
                        events.enqueue(element: result)
                    }
                    catch
                    {
                        let result = RelationshipRemoveResponse(effect.id, false)
                        events.enqueue(element: result)
                    }

                case let request as RelationshipSaveRequest:
                    do
                    {
                        try self.relationshipDatabase.save(relationship: request.relationship)
                        let result = RelationshipRemoveResponse(effect.id, true)
                        events.enqueue(element: result)
                    }
                    catch
                    {
                        let result = RelationshipRemoveResponse(effect.id, false)
                        events.enqueue(element: result)
                    }

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

                case let request as NetworkCloseRequest:
                    let uuid = request.socketId
                    if let connection = self.state.connections[uuid]
                    {
                        connection.close(request: request, state: self.state, channel: self.events)
                    }
                    else if let listener = self.state.listeners[uuid]
                    {
                        listener.close(request: request, state: self.state, channel: self.events)
                    }
                    else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

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
