//
//  DataDatabase.swift
//  Spacetime
//
//  Created by Dr. Brandon Wiley on 10/11/21.
//

import Foundation

import Datable
import Gardener
import ParchmentFile

public class IndexDatabase
{
    let root: String
    let path: URL
    var cache: [URL: ParchmentFile] = [:]

    public init(root: String) throws
    {
        self.root = root

        let url = URL(fileURLWithPath: root)
        self.path = url.appendingPathComponent("index")

        if !FileManager.default.fileExists(atPath: self.root)
        {
            try FileManager.default.createDirectory(atPath: self.root, withIntermediateDirectories: true)
        }

        if !FileManager.default.fileExists(atPath: self.path.path)
        {
            try FileManager.default.createDirectory(atPath: self.path.path, withIntermediateDirectories: true)
        }
    }

    public func count(type: String) throws -> UInt64?
    {
        let url = self.path.appendingPathComponent(type)
        if File.exists(url.path)
        {
            return try UInt64(File.size(url)) / 8
        }
        else
        {
            return nil
        }
    }

    public func load(type: String, offset: Int) throws -> UInt64?
    {
        let url = self.path.appendingPathComponent(type)
        let index: ParchmentFile
        if let parchment = self.cache[url]
        {
            index = parchment
        }
        else
        {
            index = try ParchmentFile(url)
            self.cache[url] = index
        }

        return try index.get(offset: UInt64(offset))
    }

    public func append(type: String, identifier: UInt64) throws
    {
        let url = self.path.appendingPathComponent(type)
        let index: ParchmentFile
        if let parchment = self.cache[url]
        {
            index = parchment
        }
        else
        {
            index = try ParchmentFile(url)
            self.cache[url] = index
        }

        try index.append(identifier)
    }

    public func delete(type: String, identifier: UInt64) throws
    {
        let url = self.path.appendingPathComponent(type)
        let index: ParchmentFile
        if let parchment = self.cache[url]
        {
            index = parchment
        }
        else
        {
            index = try ParchmentFile(url)
            self.cache[url] = index
        }

        guard let offset = self.getOffset(index: index, for: identifier) else
        {
            throw IndexDatabaseError.unknownValue(identifier)
        }

        try index.delete(offset: offset)
    }

    public func getOffset(index: ParchmentFile, for value: UInt64) -> UInt64?
    {
        return index.first { $0 == value }
    }
}

public enum IndexDatabaseError: Error
{
    case unknownValue(UInt64)
    case unknownName(String)
    case unknownPath(String)
    case badValue(Data)
    case couldNotMakeDirectory
}
