//
//  Failure.swift
//  
//
//  Created by Dr. Brandon Wiley on 2/3/22.
//

import Foundation

public class Failure: Event
{
    public let file: String?
    public let fileID: String?
    public let filePath: String?
    public let line: Int?
    public let column: Int?
    public let function: String?

    public override var description: String
    {
        var result = "\(self.module).Failure[effectID: \(String(describing: self.effectId))"

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

    public init(_ effectId: UUID, file: String? = nil, fileID: String? = nil, filePath: String? = nil, line: Int? = nil, column: Int? = nil, function: String? = nil)
    {
        self.file = file
        self.fileID = fileID
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function

        super.init(effectId, module: BuiltinModuleNames.general.rawValue)
    }

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case file
        case fileID
        case filePath
        case line
        case column
        case function
    }

    required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let file = try container.decode(String?.self, forKey: .file)
        let fileID = try container.decode(String?.self, forKey: .fileID)
        let filePath = try container.decode(String?.self, forKey: .filePath)
        let line = try container.decode(Int?.self, forKey: .line)
        let column = try container.decode(Int?.self, forKey: .column)
        let function = try container.decode(String?.self, forKey: .function)

        self.file = file
        self.fileID = fileID
        self.filePath = filePath
        self.line = line
        self.column = column
        self.function = function

        super.init(effectId, module: BuiltinModuleNames.general.rawValue)
    }
}
