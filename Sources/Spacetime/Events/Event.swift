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

    public init(_ effectId: UUID? = nil)
    {
        self.effectId = effectId
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
            case let event as NetworkReadResponse:
                if let effectId = event.effectId
                {
                    return "NetworkReadResponse[effectId: \(effectId), socketId: \(event.socketId), data: \(event.data.hex)]"
                }
                else
                {
                    return "NetworkReadResponse[socketId: \(event.socketId), data: \(event.data.hex)]"
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
