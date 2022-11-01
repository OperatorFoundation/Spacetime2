//
//  DateResponse.swift
//
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class DateResponse: Event
{
    public let date: Date

    public override var description: String
    {
        return "\(self.module).DateResponse[effectId: \(String(describing: self.effectId)), date: \(date)]"
    }

    public init(_ effectId: UUID, _ date: Date)
    {
        self.date = date
        
        super.init(effectId, module: BuiltinModuleNames.time.rawValue)
    }
}
