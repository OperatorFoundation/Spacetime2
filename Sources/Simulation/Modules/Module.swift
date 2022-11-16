//
//  Module.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Chord
import Foundation

#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Spacetime

public protocol Module
{
    func setLogger(logger: Logger?)
    func name() -> String
    func handleEffect(_ effect: Effect, _ channel: BlockingQueue<Event>) -> Event?
    func handleExternalEvent(_ event: Event)
}
