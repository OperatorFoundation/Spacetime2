//
//  Callback.swift
//  
//
//  Created by Dr. Brandon Wiley on 4/13/23.
//

import Foundation

public protocol Callback
{
    associatedtype ResultType where ResultType: Codable, ResultType: CustomStringConvertible
}
