//
//  Time.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import Spacetime
import Chord

extension Universe
{
    public func date() throws -> Date
    {
        let result = processEffect(DateRequest())

        switch result
        {
            case let response as DateResponse:
                return response.date
                
            default:
                throw TimeError.dateFailure
        }
    }
}

public enum TimeError: Error {
    case dateFailure
}
