//
//  Relationship+Reference.swift
//  
//
//  Created by Dr. Brandon Wiley on 1/16/23.
//

import Foundation

import Spacetime

extension Relationship
{
    public init<T>(subject: Reference<T>, relation: Relation, object: Reference<T>)
    {
        self.init(subject: subject.identifier, relation: relation, object: object.identifier)
    }
}
