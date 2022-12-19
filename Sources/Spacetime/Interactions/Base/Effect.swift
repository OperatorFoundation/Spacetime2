//
//  Effect.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

open class Effect: CustomStringConvertible, Codable
{
    public let id: UUID
    public let module: String

    open var description: String
    {
        return "Effect(\(type(of: self)))[id: \(self.id)]"
    }

    public init(id: UUID = UUID(), module: String)
    {
        self.id = id
        self.module = module
    }
}
