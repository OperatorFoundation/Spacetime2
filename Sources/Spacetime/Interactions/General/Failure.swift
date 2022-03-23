//
//  Failure.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class Failure: Event
{
    public init(_ effectId: UUID)
    {
        super.init(effectId, module: BuiltinModuleNames.general.rawValue)
    }
}
