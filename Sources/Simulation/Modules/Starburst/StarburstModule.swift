//
//  File.swift
//  
//
//  Created by Joshua Clark on 7/22/22.
//

import Chord
import Datable
import Foundation
import Spacetime

public class StarburstModule: Module
{
    static public let name =  "starburst"

    public func name() -> String
    {
        return StarburstModule.name
    }

    public func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    {
        switch effect
        {
            case is StarburstRequest:
                var message: Data?
                let formatter = DateFormatter()
                formatter.dateFormat = "hh"
                let hourString = formatter.string(from: Date())
                
                switch hourString {
                    case "01":
                        message = "01".data
                    case "02":
                        message = "02".data
                    case "03":
                        message = "03".data
                    case "04":
                        message = "04".data
                    case "05":
                        message = "05".data
                    case "06":
                        message = "06".data
                    case "07":
                        message = "07".data
                    case "08":
                        message = "08".data
                    case "09":
                        message = "09".data
                    case "10":
                        message = "10".data
                    case "11":
                        message = "11".data
                    case "12":
                        message = "12".data
                    default:
                        message = nil
                }
                    
                guard let message = message else {
                    return Failure(effect.id)
                }
                
                return StarburstResponse(effect.id, message)

            default:
                return Failure(effect.id)
        }
    }

    public func handleExternalEvent(_ event: Event)
    {
        return
    }
}
