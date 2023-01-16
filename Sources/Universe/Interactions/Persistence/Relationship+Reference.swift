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
    public init<S, T>(subject: Reference<S>, relation: Relation, object: Reference<T>)
    {
        self.init(subject: subject.identifier, relation: relation, object: object.identifier)
    }
}
