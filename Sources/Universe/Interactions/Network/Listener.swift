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

open class Listener: TransmissionTypes.Listener
{
    public let universe: Universe
    public let uuid: UUID

    public convenience init(universe: Universe, address: String, port: Int) throws
    {
        let result = universe.processEffect(ListenRequest(address, port))
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

    open func accept() throws -> TransmissionTypes.Connection
    {
        let result = self.universe.processEffect(AcceptRequest(self.uuid))
        switch result
        {
            case let response as AcceptResponse:
                return ListenConnection(universe: self.universe, response.socketId)
            default:
                throw ListenerError.acceptFailed
        }
    }

    open func close()
    {
        let result = self.universe.processEffect(NetworkListenCloseRequest(self.uuid))
        switch result
        {
            case is Affected:
                return
            default:
                return
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
    case acceptFailed
}
