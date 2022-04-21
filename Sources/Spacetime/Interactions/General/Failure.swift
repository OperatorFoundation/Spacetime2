//
//  Failure.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class Failure: Event
{
    public override var description: String
    {
        return "\(self.module).Affected[effectID: \(String(describing: self.effectId))]"
    }

    public init(_ effectId: UUID)
    {
        super.init(effectId, module: BuiltinModuleNames.general.rawValue)
    }
}
