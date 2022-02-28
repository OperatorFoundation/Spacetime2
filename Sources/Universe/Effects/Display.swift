//
//  Print.swift
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
        let lock = DispatchGroup()

        lock.enter()

        Task
        {
            await withCheckedContinuation
            {
                (continuation: CheckedContinuation<Void,Never>) in

                let effect = Display(string)
                self.effects.enqueue(element: effect)
                let _ = self.events.dequeue() // FIXME - check type of event
                continuation.resume()
            }

            lock.leave()
        }

        lock.wait()
    }
}
