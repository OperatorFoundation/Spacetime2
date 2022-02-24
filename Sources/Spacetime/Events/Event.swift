//
//  Event.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

open class Event
{
    public let effectId: UUID?

    public init(_ effectId: UUID? = nil)
    {
        self.effectId = effectId
    }
}
