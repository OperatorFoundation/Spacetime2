//
//  BuiltinModules.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Foundation

public class BuiltinModules
{
    #if os(macOS)
    static public let modules: [String: Module] = [
        DisplayModule.name: DisplayModule(),
        PersistenceModule.name: PersistenceModule(),
        RandomModule.name: RandomModule(),
        NetworkListenModule.name: NetworkListenModule(),
        NetworkConnectModule.name: NetworkConnectModule()
    ]
    #else
    static public let modules: [String: Module] = [
        DisplayModule.name: DisplayModule(),
        RandomModule.name: RandomModule(),
        NetworkListenModule.name: NetworkListenModule(),
        NetworkConnectModule.name: NetworkConnectModule(),
    ]
    #endif
}
