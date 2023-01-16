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
    public init<S, O>(subject: Reference<S>, relation: Relation, object: Reference<O>)
    {
        self.init(subject: subject.identifier, relation: relation, object: object.identifier)
    }
}
