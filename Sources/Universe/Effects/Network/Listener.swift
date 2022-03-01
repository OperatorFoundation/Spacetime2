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

public class Listener: TransmissionTypes.Listener
{
    public let universe: Universe
    public let uuid: UUID

    public convenience init(universe: Universe, address: String, port: Int) throws
    {
        let request = ListenRequest(address, port)
        universe.effects.enqueue(element: request)
        let result = universe.events.dequeue()
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

    public func accept() -> TransmissionTypes.Connection
    {
        let request = AcceptRequest(self.uuid)
        universe.effects.enqueue(element: request)

        let queue = BlockingQueue<UUID>()

        Task
        {
            let result = await withCheckedContinuation
            {
                (continuation: CheckedContinuation<UUID,Never>) in

                var maybeResult: UUID? = nil
                while maybeResult == nil
                {
                    let result = universe.events.dequeue()
                    switch result
                    {
                        case let response as AcceptResponse:
                            maybeResult = response.socketId
                        default:
                            continue
                    }
                }

                continuation.resume(returning: maybeResult!)
            }

            queue.enqueue(element: result)
        }

        let result = queue.dequeue()
        return Connection(universe: self.universe, result)
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
