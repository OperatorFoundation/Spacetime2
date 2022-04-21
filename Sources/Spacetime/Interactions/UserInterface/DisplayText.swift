//
//  DisplayText.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DisplayText: Effect
{
    public let string: String

    public override var description: String
    {
        return "\(self.module).DisplayText[id: \(self.id) string: \(self.string)]"
    }

    public init(_ string: String)
    {
        self.string = string

        super.init(module: BuiltinModuleNames.display.rawValue)
    }
}
