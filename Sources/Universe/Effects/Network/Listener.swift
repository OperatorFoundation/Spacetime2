//
//  Listener.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation
import Spacetime
import Chord

public class Listener<T> where T: Stateful
{
    public let universe: Universe<T>
    public let uuid: UUID

    public convenience init(universe: Universe<T>, address: String, port: Int) throws
    {
        let request = ListenRequest(address, port)
        universe.effects.enqueue(element: request)

        let queue = BlockingQueue<Result<UUID,Error>>()

        Task
        {
            let result = await withCheckedContinuation
            {
                (continuation: CheckedContinuation<Result<UUID,Error>,Never>) in

                var maybeResult: UUID? = nil
                while maybeResult == nil
                {
                    let result = universe.events.dequeue()
                    switch result
                    {
                        case let response as ListenResponse:
                            maybeResult = response.socketId
                        case is Failure:
                            maybeResult = nil
                        default:
                            continue
                    }
                }

                if let result = maybeResult
                {
                    continuation.resume(returning: Result.success(result))
                }
                else
                {
                    continuation.resume(returning: Result.failure(ListenerError.portInUse(port)))
                }
            }

            queue.enqueue(element: result)
        }

        let result = queue.dequeue()
        switch result
        {
            case .success(let uuid):
                self.init(universe: universe, uuid: uuid)
            case .failure(let error):
                throw error
        }
    }

    public init(universe: Universe<T>, uuid: UUID)
    {
        self.universe = universe
        self.uuid = uuid
    }

    public func accept() -> Connection<T>
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
                        case let response as ConnectResponse:
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
    public func listen(_ address: String, _ port: Int) throws -> Listener<State>
    {
        return try Listener(universe: self, address: address, port: port)
    }
}

public enum ListenerError: Error
{
    case portInUse(Int) // port
}
