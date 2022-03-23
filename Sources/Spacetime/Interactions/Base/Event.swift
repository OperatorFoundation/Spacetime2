//
//  Event.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import SwiftHexTools

open class Event
{
    public let effectId: UUID?
    public let module: String

    public init(_ effectId: UUID? = nil, module: String)
    {
        self.effectId = effectId
        self.module = module
    }
}

extension Event: CustomStringConvertible
{
    public var description: String
    {
        switch self
        {
            case let affected as Affected:
                if let effectId = affected.effectId
                {
                    return "Affected[effectId: \(effectId)]"
                }
                else
                {
                    return "Affected[]"
                }

            case let failure as Failure:
                if let effectId = failure.effectId
                {
                    return "Failure[effectId: \(effectId)]"
                }
                else
                {
                    return "Failure[]"
                }

            case let random as RandomResponse:
                if let effectId = random.effectId
                {
                    return "RandomResponse[effectId: \(effectId), value: \(random.value)]"
                }
                else
                {
                    return "RandomResponse[value: \(random.value)]"
                }

            case let event as AcceptResponse:
                if let effectId = event.effectId
                {
                    return "AcceptResponse[effectId: \(effectId), socketId: \(event.socketId)]"
                }
                else
                {
                    return "AcceptResponse[socketId: \(event.socketId)]"
                }

            case let event as ConnectResponse:
                if let effectId = event.effectId
                {
                    return "ConnectResponse[effectId: \(effectId), socketId: \(event.socketId)]"
                }
                else
                {
                    return "ConnectResponse[socketId: \(event.socketId)]"
                }

            case let event as ListenResponse:
                if let effectId = event.effectId
                {
                    return "ListenResponse[effectId: \(effectId), socketId: \(event.socketId)]"
                }
                else
                {
                    return "ListenResponse[socketId: \(event.socketId)]"
                }

            case let event as NetworkConnectReadResponse:
                if let effectId = event.effectId
                {
                    return "NetworkConnectReadResponse[effectId: \(effectId), socketId: \(event.socketId), data: \(event.data.hex)]"
                }
                else
                {
                    return "NetworkConnectReadResponse[socketId: \(event.socketId), data: \(event.data.hex)]"
                }

            case let event as NetworkListenReadResponse:
                if let effectId = event.effectId
                {
                    return "NetworkListenReadResponse[effectId: \(effectId), socketId: \(event.socketId), data: \(event.data.hex)]"
                }
                else
                {
                    return "NetworkListenReadResponse[socketId: \(event.socketId), data: \(event.data.hex)]"
                }

            default:
                if let effectId = self.effectId
                {
                    return "UnknownEvent[\(type(of: self)), effectId: \(effectId)]"
                }
                else
                {
                    return "UnknownEvent[\(type(of: self))"
                }
        }
    }
}
