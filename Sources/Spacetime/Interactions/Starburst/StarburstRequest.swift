//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/22/22.
//

import Foundation

public class StarburstRequest: Effect
{
    public override var description: String
    {
        return "\(self.module).StarburstRequest[id: \(self.id)]"
    }

    public init()
    {
        super.init(module: BuiltinModuleNames.starburst.rawValue)
    }
}
