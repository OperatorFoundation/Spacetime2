//
//  Random.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation
import _Concurrency
import Spacetime
import Chord

extension Universe
{
    public func random() -> UInt64
    {
        let queue = BlockingQueue<UInt64>()

        Task
        {
            let result = await withCheckedContinuation
            {
                (continuation: CheckedContinuation<UInt64,Never>) in

                let effect = RandomRequest()
                self.effects.enqueue(element: effect)

                var maybeResult: UInt64? = nil
                while maybeResult == nil
                {
                    let result = self.events.dequeue()
                    switch result
                    {
                        case let response as RandomResponse:
                            maybeResult = response.value
                        default:
                            continue
                    }
                }

                continuation.resume(returning: maybeResult!)
            }

            queue.enqueue(element: result)
        }

        let result = queue.dequeue()
        return result
    }
}
