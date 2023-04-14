//
//  Module.swift
//  
//
//  Created by Dr. Brandon Wiley on 3/23/22.
//

import Foundation

import Spacetime

#if os(macOS) || os(iOS)
import os.log
#else
import Logging
#endif

import Spacetime

public protocol Module
{
    associatedtype EffectType: Effect

    func handle(effect: EffectType) async -> Result<EffectType.ResponseType, GenericFailure>
}
