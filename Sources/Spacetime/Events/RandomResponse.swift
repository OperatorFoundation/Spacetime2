//
//  RandomResponse.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class RandomResponse: Event
{
    public let value: UInt64

    public init(_ effectId: UUID, _ value: UInt64)
    {
        self.value = value
        
        super.init(effectId)
    }
}
