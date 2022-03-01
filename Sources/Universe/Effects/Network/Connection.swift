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
        let result = universe.processEffect(ConnectRequest(address, port, type))
        switch result
        {
            case let response as ConnectResponse:
                self.init(universe: universe, response.socketId)
                return
            case is Failure:
                return nil
            default:
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
        let result = self.universe.processEffect(NetworkReadRequest(self.uuid, style))
        switch result
        {
            case let response as NetworkReadResponse:
                return response.data
            default:
                return Data()
        }
    }

    public func spacetimeWrite(data: Data, prefixSizeInBits: Int? = nil) -> Bool
    {
        let result = self.universe.processEffect(NetworkWriteRequest(self.uuid, data, prefixSizeInBits))
        switch result
        {
            case is Affected:
                return true
            default:
                return false
        }
    }
}

extension Universe
{
    public func connect(_ address: String, _ port: Int, _ type: ConnectionType = .tcp) throws -> Connection
    {
        guard let connection = Connection(universe: self, address: address, port: port, type: type) else
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
