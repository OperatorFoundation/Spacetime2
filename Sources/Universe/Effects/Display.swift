//
//  Display.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import Spacetime

extension Universe
{
    public func display(_ string: String)
    {
        let _ = processEffect(Display(string))
        return
    }
}
