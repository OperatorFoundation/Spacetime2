//
//  RelationshipRemoveResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 3/20/22.
//

import Foundation

public class RelationshipRemoveResponse: Event
{
    public let success: Bool

    public init(_ effectId: UUID, _ success: Bool)
    {
        self.success = success

        super.init(effectId)
    }
}
