//
//  GenericFailureResultBase.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class GenericFailure: Error, CustomStringConvertible, Codable
{
    public let effectID: UInt64
    public let file: String?
    public let fileID: String?
    public let filePath: String?
    public let line: Int?
    public let column: Int?
    public let function: String?

    public var description: String
    {
        var result = "Failure[effectID: \(String(describing: self.effectID))"

        if let file = self.file
        {
            result.append(", file: \(file)/\(self.fileID ?? "")")
        }

        if let line = self.line
        {
            result.append(" line: \(line)")

            if let column = self.column
            {
                result.append(":\(column)")
            }
        }

        if let function = self.function
        {
            result.append(" \(function)()")
        }

        result.append("]")

        return result
    }

    public init(_ effectID: UInt64, file: String? = nil, fileID: String? = nil, filePath: String? = nil, line: Int? = nil, column: Int? = nil, function: String? = nil)
    {
        self.effectID = effectID
        self.file = file
        self.fileID = fileID
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function
    }

    enum CodingKeys: String, CodingKey
    {
        case effectID
        case file
        case fileID
        case filePath
        case line
        case column
        case function
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectID = try container.decode(UInt64.self, forKey: .effectID)
        let file = try container.decode(String?.self, forKey: .file)
        let fileID = try container.decode(String?.self, forKey: .fileID)
        let filePath = try container.decode(String?.self, forKey: .filePath)
        let line = try container.decode(Int?.self, forKey: .line)
        let column = try container.decode(Int?.self, forKey: .column)
        let function = try container.decode(String?.self, forKey: .function)

        self.effectID = effectID
        self.file = file
        self.fileID = fileID
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function
    }
}
