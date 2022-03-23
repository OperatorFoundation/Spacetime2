//
//  DataDatabase.swift
//  Spacetime
//
//  Created by Dr. Brandon Wiley on 10/11/21.
//

import Foundation
import Datable
import Gardener

public class DataDatabase
{
    static public let instance: DataDatabase = DataDatabase(root: "dataDatabase")

    let root: String
    let path: String

    let validName = try! NSRegularExpression(pattern: #"^[0-9]+$"#, options: [])
    var nextIndex: UInt64

    public init(root: String)
    {
        self.root = root
        self.path = "\(self.root)/data"

        if !File.exists(self.root)
        {
            let _ = File.makeDirectory(atPath: self.root)
        }

        if !File.exists(self.path)
        {
            let _ = File.makeDirectory(atPath: self.path)
        }

        do
        {
            self.nextIndex = try DataDatabase.findNextIndex(path: self.path)
        }
        catch
        {
            self.nextIndex = 0
            let _ = DataDatabase.saveNextIndex(path: self.path, index: self.nextIndex)
        }
    }

    public func loadUInt64(path: String) throws -> UInt64
    {
        let url = URL(fileURLWithPath: "\(self.path)/\(path)")
        let data = try Data(contentsOf: url)
        guard let uint64 = data.maybeNetworkUint64 else {throw DataDatabaseError.badValue(data)}
        return uint64
    }

    public func saveUInt64(uint64: UInt64, path: String) throws
    {
        let data = uint64.maybeNetworkData!
        let url = URL(fileURLWithPath: "\(self.path)/\(path)")
        try data.write(to: url)
    }

    public func exists(identifier: UInt64) -> Bool
    {
        let filename = "\(self.path)/\(identifier)"
        return FileManager.default.fileExists(atPath: filename)
    }

    func load(path: String) throws -> Data
    {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        return data
    }

    func save(data: Data, filename: String) throws
    {
        let url = URL(fileURLWithPath: "\(self.path)/\(filename)")
        try data.write(to: url)
    }

    public func contains(_ name: String) -> Bool
    {
        return FileManager.default.fileExists(atPath: "\(self.path)/\(name)")
    }

    static public func findNextIndex(path: String) throws -> UInt64
    {
        let filename = "\(path)/nextIndex"

        guard let data = FileManager.default.contents(atPath: filename) else {throw DataDatabaseError.unknownPath(filename)}
        guard let result = data.maybeNetworkUint64 else {throw DataDatabaseError.badValue(data)}
        return result
    }

    static public func saveNextIndex(path: String, index: UInt64) -> Bool
    {
        let filename = "\(path)/nextIndex"

        guard let data = index.maybeNetworkData else {return false}

        FileManager.default.createFile(atPath: filename, contents: data, attributes: nil)

        return true
    }

    public func allocateIdentifier() -> UInt64?
    {
        let identifier = self.nextIndex

        guard identifier != UInt64.max else {return nil}

        self.nextIndex = self.nextIndex + 1
        guard DataDatabase.saveNextIndex(path: self.path, index: self.nextIndex) else {return nil}

        return identifier
    }

    public func getStatic(identifier: UInt64) throws -> Data
    {
        let filename = "\(self.path)/\(identifier)"

        guard FileManager.default.fileExists(atPath: filename) else {throw DataDatabaseError.unknownName(filename)}

        return try load(path: filename)
    }

    public func save(identifier: UInt64, type: String, data: Data) throws
    {
        let filename = identifier.string
        let typeFilename = "\(self.path)/\(identifier).type"

        let typeData = type.data
        try typeData.write(to: URL(fileURLWithPath: typeFilename))
        
        try save(data: data, filename: filename)
    }

    public func delete(identifier: UInt64) -> Bool
    {
        let filename = "\(self.path)/\(identifier)"
        let typeFilename = "\(self.path)/\(identifier).type"

        guard FileManager.default.fileExists(atPath: filename) else {return false}

        do
        {
            try FileManager.default.removeItem(atPath: filename)
            try FileManager.default.removeItem(atPath: typeFilename)
        }
        catch
        {
            return false
        }

        return true
    }

}

public enum DataDatabaseError: Error
{
    case unknownName(String)
    case unknownPath(String)
    case badValue(Data)
    case couldNotMakeDirectory
}
