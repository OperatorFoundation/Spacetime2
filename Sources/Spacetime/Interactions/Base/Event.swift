//
//  Event.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import SwiftHexTools

open class Event: CustomStringConvertible
{
    public let effectId: UUID?
    public let module: String

    public var description: String
    {
        return "\(self.module).Event(\(type(of: self)))[effectId: \(String(describing: self.effectId))]"
    }

    public init(_ effectId: UUID? = nil, module: String)
    {
        self.effectId = effectId
        self.module = module
    }
}
