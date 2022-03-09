//
//  SimulationConnection.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/1/22.
//

import Chord
import Foundation
import Spacetime
import TransmissionTypes

public class SimulationConnection
{
    let networkConnection: TransmissionTypes.Connection
    fileprivate var reads: [UUID: Read] = [:]
    fileprivate var writes: [UUID: Write] = [:]
    fileprivate var closes: [UUID: Close] = [:]

    public init(_ networkConnection: TransmissionTypes.Connection)
    {
        self.networkConnection = networkConnection
    }

    public func read(request: NetworkReadRequest, channel: BlockingQueue<Event>)
    {
        let read = Read(simulationConnection: self, networkConnection: self.networkConnection, request: request, events: channel)
        self.reads[read.uuid] = read
    }

    public func write(request: NetworkWriteRequest, channel: BlockingQueue<Event>)
    {
        let write = Write(simulationConnection: self, networkConnection: self.networkConnection, request: request, events: channel)
        self.writes[write.uuid] = write
    }

    public func close(request: NetworkCloseRequest, state: SimulationState, channel: BlockingQueue<Event>)
    {
        let close = Close(simulationConnection: self, networkConnection: self.networkConnection, state: state, request: request, events: channel)
        self.closes[close.uuid] = close
    }
}

fileprivate struct Read
{
    let simulationConnection: SimulationConnection
    let networkConnection: TransmissionTypes.Connection
    let request: NetworkReadRequest
    let events: BlockingQueue<Event>
    let queue = DispatchQueue(label: "SimulationConnection.Read")
    let response: NetworkReadResponse? = nil
    let uuid = UUID()

    public init(simulationConnection: SimulationConnection, networkConnection: TransmissionTypes.Connection, request: NetworkReadRequest, events: BlockingQueue<Event>)
    {
        self.simulationConnection = simulationConnection
        self.networkConnection = networkConnection
        self.request = request
        self.events = events

        let uuid = self.uuid

        self.queue.async
        {
            switch request.style
            {
                case .exactSize(let size):
                    guard let result = networkConnection.read(size: size) else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    let response = NetworkReadResponse(request.id, request.socketId, result)
                    events.enqueue(element: response)
                case .maxSize(let size):
                    guard let result = networkConnection.read(maxSize: size) else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    let response = NetworkReadResponse(request.id, request.socketId, result)
                    events.enqueue(element: response)
                case .lengthPrefixSizeInBits(let prefixSize):
                    guard let result = networkConnection.readWithLengthPrefix(prefixSizeInBits: prefixSize) else
                    {
                        let failure = Failure(request.id)
                        events.enqueue(element: failure)
                        return
                    }

                    let response = NetworkReadResponse(request.id, request.socketId, result)
                    events.enqueue(element: response)
            }

            simulationConnection.reads.removeValue(forKey: uuid)
        }
    }
}

fileprivate struct Write
{
    let simulationConnection: SimulationConnection
    let networkConnection: TransmissionTypes.Connection
    let request: NetworkWriteRequest
    let events: BlockingQueue<Event>
    let queue = DispatchQueue(label: "SimulationConnection.Write")
    let uuid = UUID()

    public init(simulationConnection: SimulationConnection, networkConnection: TransmissionTypes.Connection, request: NetworkWriteRequest, events: BlockingQueue<Event>)
    {
        self.simulationConnection = simulationConnection
        self.networkConnection = networkConnection
        self.request = request
        self.events = events

        let uuid = self.uuid

        queue.async
        {
            if let prefixSize = request.lengthPrefixSizeInBits
            {
                guard networkConnection.writeWithLengthPrefix(data: request.data, prefixSizeInBits: prefixSize) else
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
                guard networkConnection.write(data: request.data) else
                {
                    let failure = Failure(request.id)
                    events.enqueue(element: failure)
                    return
                }

                let response = Affected(request.id)
                events.enqueue(element: response)
            }

            simulationConnection.writes.removeValue(forKey: uuid)
        }
    }
}

fileprivate struct Close
{
    let simulationConnection: SimulationConnection
    let networkConnection: TransmissionTypes.Connection
    let request: NetworkCloseRequest
    let state: SimulationState
    let events: BlockingQueue<Event>
    let queue = DispatchQueue(label: "SimulationConnection.Close")
    let uuid = UUID()

    public init(simulationConnection: SimulationConnection, networkConnection: TransmissionTypes.Connection, state: SimulationState, request: NetworkCloseRequest, events: BlockingQueue<Event>)
    {
        self.simulationConnection = simulationConnection
        self.networkConnection = networkConnection
        self.state = state
        self.request = request
        self.events = events

        let uuid = self.uuid

        queue.async
        {
            networkConnection.close()

            let response = Affected(request.id)
            events.enqueue(element: response)

            state.connections.removeValue(forKey: uuid)
            simulationConnection.closes.removeValue(forKey: uuid)
        }
    }
}
