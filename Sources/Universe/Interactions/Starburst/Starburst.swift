//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/22/22.
//

import Foundation
import Spacetime
import Chord

extension Universe
{
    public func starburst() throws -> Data
    {
        let result = processEffect(StarburstRequest())

        switch result
        {
            case let response as StarburstResponse:
                return response.message
                
            default:
                throw StarburstError.starburstFailure
        }
    }
}

public enum StarburstError: Error {
    case starburstFailure
}
