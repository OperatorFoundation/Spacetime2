//
//  Effect.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

open class Effect: CustomStringConvertible
{
    public let id: UUID = UUID()
    public let module: String

    public var description: String
    {
        return "Effect(\(type(of: self)))[id: \(self.id)]"
    }

    public init(module: String)
    {
        self.module = module
    }
}
