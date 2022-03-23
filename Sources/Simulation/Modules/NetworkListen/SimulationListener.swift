//
//  Listener.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/1/22.
//

import Chord
import Foundation
import Spacetime
import TransmissionTypes

public class SimulationListener
{
    let networkListener: TransmissionTypes.Listener
    fileprivate var accepts: [UUID: Accept] = [:]
    fileprivate var closes: [UUID: Close] = [:]

    public init(_ networkListener: TransmissionTypes.Listener)
    {
        self.networkListener = networkListener
    }

    public func accept(request: AcceptRequest, state: NetworkListenModule, channel: BlockingQueue<Event>)
    {
        let accept = Accept(simulationListener: self, networkListener: self.networkListener, state: state, request: request, events: channel)
        self.accepts[accept.uuid] = accept
    }

    public func close(request: NetworkListenCloseRequest, state: NetworkListenModule, channel: BlockingQueue<Event>)
    {
        let close = Close(simulationListener: self, networkListener: self.networkListener, state: state, request: request, events: channel)
        self.closes[close.uuid] = close
    }
}

fileprivate struct Accept
{
    let simulationListener: SimulationListener
    let networkListener: TransmissionTypes.Listener
    let request: AcceptRequest
    let events: BlockingQueue<Event>
    let queue = DispatchQueue(label: "SimulationListener.Accept")
    let response: AcceptResponse? = nil
    let state: NetworkListenModule
    let uuid = UUID()

    public init(simulationListener: SimulationListener, networkListener: TransmissionTypes.Listener, state: NetworkListenModule, request: AcceptRequest, events: BlockingQueue<Event>)
    {
        self.simulationListener = simulationListener
        self.networkListener = networkListener
        self.state = state
        self.request = request
        self.events = events

        let uuid = self.uuid

        self.queue.async
        {
            do
            {
                let networkAccepted = try networkListener.accept()
                let accepted = SimulationListenConnection(networkAccepted)
                state.connections[uuid] = accepted
                let response = AcceptResponse(request.id, uuid)
                events.enqueue(element: response)
                simulationListener.accepts.removeValue(forKey: uuid)
            }
            catch
            {
                let response = Failure(request.id)
                events.enqueue(element: response)
                simulationListener.accepts.removeValue(forKey: uuid)
            }
        }
    }
}

fileprivate struct Close
{
    let simulationListener: SimulationListener
    let networkListener: TransmissionTypes.Listener
    let state: NetworkListenModule
    let request: NetworkListenCloseRequest
    let events: BlockingQueue<Event>
    let queue = DispatchQueue(label: "SimulationConnection.Close")
    let uuid = UUID()

    public init(simulationListener: SimulationListener, networkListener: TransmissionTypes.Listener, state: NetworkListenModule, request: NetworkListenCloseRequest, events: BlockingQueue<Event>)
    {
        self.simulationListener = simulationListener
        self.networkListener = networkListener
        self.state = state
        self.request = request
        self.events = events

        let uuid = self.uuid

        queue.async
        {
            networkListener.close()

            let response = Affected(request.id)
            events.enqueue(element: response)

            state.listeners.removeValue(forKey: uuid)
            simulationListener.closes.removeValue(forKey: uuid)
        }
    }
}
