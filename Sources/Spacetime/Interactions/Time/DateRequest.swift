//
//  DateRequest.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DateRequest: Effect
{
    public override var description: String
    {
        return "\(self.module).DateRequest[id: \(self.id)]"
    }

    public init()
    {
        super.init(module: BuiltinModuleNames.time.rawValue)
    }
}
