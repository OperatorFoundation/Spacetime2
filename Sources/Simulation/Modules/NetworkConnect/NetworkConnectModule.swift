//
//  NetworkConnectModule.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation
import Spacetime
import Transmission

public class NetworkConnectModule: Module
{
    static public let name = "networkConnect"

    public var connections: [UUID: SimulationConnectConnection] = [:]

    public func name() -> String
    {
        return NetworkConnectModule.name
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case let request as ConnectRequest:
                guard let uuid = self.connect(host: request.address, port: request.port, type: request.type) else
                {
                    let failure = Failure(effect.id)
                    print(failure.description)
                    return failure
                }

                let response = ConnectResponse(effect.id, uuid)
                print(response.description)
                return response

            case let request as NetworkConnectReadRequest:
                let uuid = request.socketId
                guard let connection = self.connections[uuid] else
                {
                    let failure = Failure(effect.id)
                    print(failure.description)
                    return failure
                }

                connection.read(request: request, channel: channel)
                return nil

            case let request as NetworkConnectWriteRequest:
                let uuid = request.socketId
                guard let connection = self.connections[uuid] else
                {
                    let failure = Failure(effect.id)
                    print(failure.description)
                    return failure
                }

                connection.write(request: request, channel: channel)
                return nil

            case let request as NetworkConnectCloseRequest:
                let uuid = request.socketId
                if let connection = self.connections[uuid]
                {
                    connection.close(request: request, state: self, channel: channel)
                    return nil
                }
                else
                {
                    let failure = Failure(effect.id)
                    print(failure.description)
                    return failure
                }

            default:
                let failure = Failure(effect.id)
                print(failure.description)
                return failure
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }

    func connect(host: String, port: Int, type: ConnectionType) -> UUID?
    {
        let uuid = UUID()
        guard let networkConnection = TransmissionConnection(host: host, port: port, type: type, logger: nil) else
        {
            return nil
        }

        let connection = SimulationConnectConnection(networkConnection)
        self.connections[uuid] = connection

        return uuid
    }
}
