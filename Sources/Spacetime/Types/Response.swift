//
//  Result.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/13/23.
//

import Foundation

public protocol Response: Codable, CustomStringConvertible
{
    var effectID: UInt64 { get }
}

public class ResponseBase: Response
{
    public var effectID: UInt64

    public var description: String
    {
        return "[ResultBase: effectID=\(self.effectID)]"
    }

    public init(effectID: UInt64)
    {
        self.effectID = effectID
    }
}

