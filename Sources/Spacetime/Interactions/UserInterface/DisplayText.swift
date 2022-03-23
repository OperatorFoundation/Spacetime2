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

    public init(_ string: String)
    {
        self.string = string

        super.init(module: BuiltinModuleNames.display.rawValue)
    }
}
