//
//  RandomRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class RandomRequest: Effect
{
    public init()
    {
        super.init(module: BuiltinModuleNames.random.rawValue)
    }
}
