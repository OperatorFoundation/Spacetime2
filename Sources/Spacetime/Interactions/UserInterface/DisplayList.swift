//
//  DisplayList.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DisplayList: Effect
{
    public let list: [String]

    public init(_ list: [String])
    {
        self.list = list

        super.init(module: BuiltinModuleNames.display.rawValue)
    }
}
