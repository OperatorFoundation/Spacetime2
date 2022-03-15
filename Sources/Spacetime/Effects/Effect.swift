//
//  Effect.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

open class Effect
{
    public let id: UUID = UUID()

    public init()
    {
    }
}

extension Effect: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
            case let display as Display:
                return "Display[id: \(display.id) string: \(display.string)]"
            case let random as RandomRequest:
                return "Random[id: \(random.id)]"
            case let listen as ListenRequest:
                if let address = listen.address
                {
                    return "Listen[id: \(listen.id), address: \(address), port: \(listen.port)]"
                }
                else
                {
                    return "Listen[id: \(listen.id), address: nil, port: \(listen.port)]"
                }
            case let accept as AcceptRequest:
                return "Accept[id: \(accept.id), socketId: \(accept.socketId)]"
            case let connect as ConnectRequest:
                return "Connect[id: \(connect.id), address: \(connect.address), port: \(connect.port), type: \(connect.type)]"
            case let write as NetworkWriteRequest:
                if let prefix = write.lengthPrefixSizeInBits
                {
                    return "NetworkWriteRequest[id: \(write.id), socketId: \(write.socketId), data: \(write.data.hex), lengthPrefixSizeInBits: \(prefix)]"
                }
                else
                {
                    return "NetworkWriteRequest[id: \(write.id), socketId: \(write.socketId), data: \(write.data.hex), lengthPrefixSizeInBits: nil]"
                }
            case let read as NetworkReadRequest:
                return "NetworkReadRequest[id: \(read.id), socketId: \(read.socketId), style: \(read.style.description)]"
            default:
                return "UnknownEffect[\(type(of: self)), id: \(self.id)]"
        }
    }
}
