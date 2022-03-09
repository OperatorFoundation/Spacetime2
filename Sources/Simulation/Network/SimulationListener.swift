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
    var accepts: [UUID: Accept] = [:]

    public init(_ networkListener: TransmissionTypes.Listener)
    {
        self.networkListener = networkListener
    }

    public func accept(request: AcceptRequest, state: SimulationState, channel: BlockingQueue<Event>)
    {
        let accept = Accept(simulationListener: self, networkListener: self.networkListener, state: state, request: request, events: channel)
        self.accepts[accept.uuid] = accept
    }
}

public struct Accept
{
    let simulationListener: SimulationListener
    let networkListener: TransmissionTypes.Listener
    let request: AcceptRequest
    let events: BlockingQueue<Event>
    let queue = DispatchQueue(label: "SimulationListener.Accept")
    let response: AcceptResponse? = nil
    let state: SimulationState
    let uuid = UUID()

    public init(simulationListener: SimulationListener, networkListener: TransmissionTypes.Listener, state: SimulationState, request: AcceptRequest, events: BlockingQueue<Event>)
    {
        self.simulationListener = simulationListener
        self.networkListener = networkListener
        self.state = state
        self.request = request
        self.events = events

        let uuid = self.uuid

        self.queue.async
        {
            let networkAccepted = try networkListener.accept()
            let accepted = SimulationConnection(networkAccepted)
            state.connections[uuid] = accepted
            let response = AcceptResponse(request.id, uuid)
            events.enqueue(element: response)
            simulationListener.accepts.removeValue(forKey: uuid)
        }
    }
}
