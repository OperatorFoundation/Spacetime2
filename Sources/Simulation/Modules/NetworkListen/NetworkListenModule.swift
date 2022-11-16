//
//  NetworkListenModule.swift
//
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation

#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Spacetime
import Transmission

public class NetworkListenModule: Module
{
    static public let name = "networkListen"

    public var logger: Logger?
    public var listeners: [UUID: SimulationListener] = [:]
    public var connections: [UUID: SimulationListenConnection] = [:]

    public func name() -> String
    {
        return NetworkListenModule.name
    }
    
    public func setLogger(logger: Logger?)
    {
        self.logger = logger
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case let request as AcceptRequest:
                let listenUuid = request.socketId
                guard let listener = self.listeners[listenUuid] else
                {
                    return Failure(request.id)
                }

                listener.accept(request: request, state: self, channel: channel)
                return nil

            case let request as ListenRequest:
                guard let uuid = listen(port: request.port, type: request.type) else
                {
                    return Failure(effect.id)
                }

                return ListenResponse(effect.id, uuid)

            case let request as NetworkListenReadRequest:
                let uuid = request.socketId
                guard let connection = self.connections[uuid] else
                {
                    return Failure(request.id)
                }

                connection.read(request: request, channel: channel)
                return nil

            case let request as NetworkListenWriteRequest:
                let uuid = request.socketId
                guard let connection = self.connections[uuid] else
                {
                    return Failure(request.id)
                }

                connection.write(request: request, channel: channel)
                return nil

            case let request as NetworkListenCloseRequest:
                let uuid = request.socketId
                if let connection = self.connections[uuid]
                {
                    connection.close(request: request, state: self, channel: channel)
                    return nil
                }
                else if let listener = self.listeners[uuid]
                {
                    listener.close(request: request, state: self, channel: channel)
                    return nil
                }
                else
                {
                    return Failure(request.id)
                }

            default:
                return Failure(effect.id)
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }

    func listen(port: Int, type: ConnectionType) -> UUID?
    {
        let uuid = UUID()
        guard let networkListener = TransmissionListener(port: port, type: type, logger: nil) else
        {
            return nil
        }

        let listener = SimulationListener(networkListener)
        self.listeners[uuid] = listener

        return uuid
    }
}
