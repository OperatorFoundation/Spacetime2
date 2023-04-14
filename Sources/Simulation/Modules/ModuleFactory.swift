//
//  ModuleFactory.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/13/23.
//

import Foundation

public protocol ModuleFactory
{
    associatedtype Product: Module
}
