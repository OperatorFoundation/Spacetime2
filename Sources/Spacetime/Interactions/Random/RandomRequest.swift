//
//  RandomRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class RandomRequest: Effect
{
    public override var description: String
    {
        return "\(self.module).RandomRequest[id: \(self.id)]"
    }

    public init()
    {
        super.init(module: BuiltinModuleNames.random.rawValue)
    }
}
