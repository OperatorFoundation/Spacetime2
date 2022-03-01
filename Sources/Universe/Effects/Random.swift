//
//  Random.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import Spacetime
import Chord

extension Universe
{
    public func random() -> UInt64?
    {
        let result = processEffect(RandomRequest())

        switch result
        {
            case let response as RandomResponse:
                return response.value
            default:
                return nil
        }
    }
}
