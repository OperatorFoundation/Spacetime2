//
//  Connection.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Chord
import Datable
import Foundation
import Spacetime
import TransmissionTypes

public class Connection: TransmissionTypes.Connection
{
    public let universe: Universe
    public let uuid: UUID

    public convenience init?(universe: Universe, address: String, port: Int, type: ConnectionType = .tcp)
    {
        let request = ConnectRequest(address, port, type)
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

    public init(universe: Universe, _ uuid: UUID)
    {
        self.universe = universe
        self.uuid = uuid
    }

    public func read(size: Int) -> Data?
    {
        return self.read(.exactSize(size))
    }

    public func read(maxSize: Int) -> Data?
    {
        return self.read(.maxSize(maxSize))
    }

    public func readWithLengthPrefix(prefixSizeInBits: Int) -> Data?
    {
        return self.read(.lengthPrefixSizeInBits(prefixSizeInBits))
    }

    public func write(string: String) -> Bool
    {
        return self.write(data: string.data)
    }

    public func write(data: Data) -> Bool
    {
        return self.spacetimeWrite(data: data)
    }

    public func writeWithLengthPrefix(data: Data, prefixSizeInBits: Int) -> Bool
    {
        return self.spacetimeWrite(data: data, prefixSizeInBits: prefixSizeInBits)
    }

    func read(_ style: NetworkReadStyle) -> Data
    {
        let effect = NetworkReadRequest(self.uuid, style)
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

    public func spacetimeWrite(data: Data, prefixSizeInBits: Int? = nil) -> Bool
    {
        let effect = NetworkWriteRequest(self.uuid, data, prefixSizeInBits)
        self.universe.effects.enqueue(element: effect)

        let queue = BlockingQueue<Bool>()

        Task
        {
            let result = await withCheckedContinuation
            {
                (continuation: CheckedContinuation<Bool,Never>) in

                var maybeResult: Bool? = nil
                while maybeResult == nil
                {
                    let result = universe.events.dequeue()
                    switch result
                    {
                        case is Affected:
                            maybeResult = true
                        default:
                            maybeResult = false
                    }
                }

                continuation.resume(returning: maybeResult!)
            }

            queue.enqueue(element: result)
        }

        let result = queue.dequeue()
        return result
    }
}

extension Universe
{
    public func connect(_ address: String, _ port: Int) throws -> Connection
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
