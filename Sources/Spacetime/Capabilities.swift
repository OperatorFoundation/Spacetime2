//
//  Capabilities.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/24/22.
//

import Foundation

public struct Capabilities
{
    var capabilities: Set<String> = Set<String>()

    public init(_ capabilityList: String...)
    {
        for capability in capabilityList
        {
            self.capabilities.insert(capability.lowercased())
        }
    }

    public init(_ capabilityList: [String])
    {
        for capability in capabilityList
        {
            self.capabilities.insert(capability.lowercased())
        }
    }

    public init(_ names: BuiltinModuleNames...)
    {
        let list = names.map {$0.rawValue.lowercased()}
        self.init(list)
    }

    public func hasCapability(_ name: String) -> Bool
    {
        return self.capabilities.contains(name.lowercased())
    }
}
