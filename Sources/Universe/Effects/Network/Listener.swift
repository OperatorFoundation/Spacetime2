//
//  Listener.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Chord
import Foundation
import Spacetime
import TransmissionTypes

public class Listener
{
    public let universe: Universe
    public let uuid: UUID

    public convenience init(universe: Universe, address: String, port: Int) throws
    {
        print("listener.init - calling process effect")
        let result = universe.processEffect(ListenRequest(address, port))
        print("listener process finished")
        switch result
        {
            case let response as ListenResponse:
                self.init(universe: universe, uuid: response.socketId)
                return
            case is Failure:
                throw ListenerError.badResponse(result)
            default:
                throw ListenerError.badResponse(result)
        }
    }

    public init(universe: Universe, uuid: UUID)
    {
        self.universe = universe
        self.uuid = uuid
    }

    public func accept() -> TransmissionTypes.Connection?
    {
        let result = self.universe.processEffect(AcceptRequest(self.uuid))
        switch result
        {
            case let response as AcceptResponse:
                return Connection(universe: self.universe, response.socketId)
            default:
                return nil
        }
    }
}

extension Universe
{
    public func listen(_ address: String, _ port: Int) throws -> Listener
    {
        return try Listener(universe: self, address: address, port: port)
    }
}

public enum ListenerError: Error
{
    case portInUse(Int) // port
    case badResponse(Event)
}
