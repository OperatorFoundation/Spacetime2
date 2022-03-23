//
//  ListenRequest.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/4/22.
//

import Foundation

public class ListenRequest: Effect
{
    public let address: String?
    public let port: Int

    public init(_ address: String?, _ port: Int)
    {
        self.address = address
        self.port = port

        super.init()
    }
}
