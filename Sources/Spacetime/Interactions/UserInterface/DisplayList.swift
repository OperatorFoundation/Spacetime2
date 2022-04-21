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

    public override var description: String
    {
        return "\(self.module).DisplayList[id: \(self.id) list: \(self.list)]"
    }

    public init(_ list: [String])
    {
        self.list = list

        super.init(module: BuiltinModuleNames.display.rawValue)
    }
}
