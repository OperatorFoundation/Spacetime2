//
//  Connection.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation
import Spacetime
import Chord

public class Connection<T> where T: Stateful
{
    public let universe: Universe<T>
    public let uuid: UUID

    public convenience init?(universe: Universe<T>, address: String, port: Int)
    {
        let request = ConnectRequest(address, port)
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
                        case let response as ConnectResponse:
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
                    continuation.resume(returning: Result.failure(ConnectionError.connectionRefused))
                }
            }

            queue.enqueue(element: result)
        }

        let result = queue.dequeue()
        switch result
        {
            case .success(let uuid):
                self.init(universe: universe, uuid)
            case .failure(_):
                return nil
        }
    }

    public init(universe: Universe<T>, _ uuid: UUID)
    {
        self.universe = universe
        self.uuid = uuid
    }

    public func read(size: UInt64) -> Data
    {
        let effect = NetworkReadRequest(self.uuid, size)
        self.universe.effects.enqueue(element: effect)

        let queue = BlockingQueue<Data>()

        Task
        {
            let result = await withCheckedContinuation
            {
                (continuation: CheckedContinuation<Data,Never>) in

                var maybeResult: Data? = nil
                while maybeResult == nil
                {
                    let result = universe.events.dequeue()
                    switch result
                    {
                        case let response as NetworkReadResponse:
                            maybeResult = response.data
                        default:
                            continue
                    }
                }

                continuation.resume(returning: maybeResult!)
            }

            queue.enqueue(element: result)
        }

        let result = queue.dequeue()
        return result
    }

    public func write(data: Data)
    {
        let lock = DispatchGroup()

        lock.enter()

        Task
        {
            let effect = NetworkWriteRequest(self.uuid, data)
            self.universe.effects.enqueue(element: effect)

            await withCheckedContinuation
            {
                (continuation: CheckedContinuation<Void,Never>) in

                let _ = self.universe.events.dequeue() // FIXME - check type of event
                continuation.resume()
            }

            lock.leave()
        }

        lock.wait()
    }
}

extension Universe
{
    public func connect(_ address: String, _ port: Int) throws -> Connection<State>
    {
        guard let connection = Connection(universe: self, address: address, port: port) else
        {
            throw ConnectionError.connectionRefused
        }

        return connection
    }
}

public enum ConnectionError: Error
{
    case connectionRefused
}
