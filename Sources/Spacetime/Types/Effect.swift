//
//  Effect.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public protocol Effect
{
    associatedtype ResponseType where ResponseType: Response

    var id: UInt64 { get }
}

open class EffectBase: CustomStringConvertible, Codable
{
    public let id: UInt64
    public let module: String

    open var description: String
    {
        return "Effect(\(type(of: self)))[id: \(self.id)]"
    }

    public init(id: UInt64 = UInt64.random(in: 0..<UInt64.max), module: String)
    {
        self.id = id
        self.module = module
    }
}
