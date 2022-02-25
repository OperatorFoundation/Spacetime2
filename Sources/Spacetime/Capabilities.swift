//
//  Capabilities.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/24/22.
//

import Foundation

public struct Capabilities
{
    public let display: Bool
    public let networkConnect: Bool
    public let networkListen: Bool
    public let random: Bool

    public init(display: Bool, networkConnect: Bool = false, networkListen: Bool = false, random: Bool = false)
    {
        self.display = display
        self.networkConnect = networkConnect
        self.networkListen = networkListen
        self.random = random
    }
}
