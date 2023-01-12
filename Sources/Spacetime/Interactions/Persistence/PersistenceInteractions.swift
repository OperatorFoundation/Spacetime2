//
//  PersistenceInteractions.swift
//
//
//  Created by ClockworkSpacetime on Jan 12, 2023.
//

import Foundation

public class PersistenceEffect: Effect
{
    enum CodingKeys: String, CodingKey
    {
        case id
    }

    public init()
    {
        super.init(module: "Persistence")
    }

    public init(id: UUID)
    {
        super.init(id: id, module: "Persistence")
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)

        super.init(id: id, module: "Persistence")
    }
}

public class PersistenceEvent: Event
{
    enum CodingKeys: String, CodingKey
    {
        case effectId
    }

    public init(_ effectId: UUID)
    {
        super.init(effectId, module: "Persistence")
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)

        super.init(effectId, module: "Persistence")
    }
}

public class PersistenceAllocateidentifierRequest: PersistenceEffect
{
    enum CodingKeys: String, CodingKey
    {
        case id
    }

    public override init()
    {
        super.init()
    }

    public override init(id: UUID)
    {
        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)

        super.init(id: id)
    }
}

public class PersistenceAllocateidentifierResponse: PersistenceEvent
{
    public let result: UInt64

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: UInt64)
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode(UInt64.self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceExistsRequest: PersistenceEffect
{
    public let identifier: UInt64

    enum CodingKeys: String, CodingKey
    {
        case id
        case identifier
    }

    public init(identifier: UInt64)
    {
        self.identifier = identifier

        super.init()
    }

    public init(id: UUID, identifier: UInt64)
    {
        self.identifier = identifier

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let identifier: UInt64 = try container.decode(UInt64.self, forKey: .identifier)

        self.identifier = identifier
        super.init(id: id)
    }
}

public class PersistenceExistsResponse: PersistenceEvent
{
    public let result: Bool

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: Bool)
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode(Bool.self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceLoaddataRequest: PersistenceEffect
{
    public let identifier: UInt64

    enum CodingKeys: String, CodingKey
    {
        case id
        case identifier
    }

    public init(identifier: UInt64)
    {
        self.identifier = identifier

        super.init()
    }

    public init(id: UUID, identifier: UInt64)
    {
        self.identifier = identifier

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let identifier: UInt64 = try container.decode(UInt64.self, forKey: .identifier)

        self.identifier = identifier
        super.init(id: id)
    }
}

public class PersistenceLoaddataResponse: PersistenceEvent
{
    public let result: Data

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: Data)
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode(Data.self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceSavedataRequest: PersistenceEffect
{
    public let identifier: UInt64
    public let type: String
    public let data: Data

    enum CodingKeys: String, CodingKey
    {
        case id
        case identifier
        case type
        case data
    }

    public init(identifier: UInt64, type: String, data: Data)
    {
        self.identifier = identifier
        self.type = type
        self.data = data

        super.init()
    }

    public init(id: UUID, identifier: UInt64, type: String, data: Data)
    {
        self.identifier = identifier
        self.type = type
        self.data = data

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let identifier: UInt64 = try container.decode(UInt64.self, forKey: .identifier)
        let type: String = try container.decode(String.self, forKey: .type)
        let data: Data = try container.decode(Data.self, forKey: .data)

        self.identifier = identifier
        self.type = type
        self.data = data
        super.init(id: id)
    }
}

public class PersistenceSavedataResponse: PersistenceEvent
{
    enum CodingKeys: String, CodingKey
    {
        case effectId
    }

    public override init(_ effectId: UUID)
    {
        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)

        super.init(effectId)
    }
}

public class PersistenceDeletedataRequest: PersistenceEffect
{
    public let identifier: UInt64

    enum CodingKeys: String, CodingKey
    {
        case id
        case identifier
    }

    public init(identifier: UInt64)
    {
        self.identifier = identifier

        super.init()
    }

    public init(id: UUID, identifier: UInt64)
    {
        self.identifier = identifier

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let identifier: UInt64 = try container.decode(UInt64.self, forKey: .identifier)

        self.identifier = identifier
        super.init(id: id)
    }
}

public class PersistenceDeletedataResponse: PersistenceEvent
{
    public let result: Bool

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: Bool)
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode(Bool.self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceCountRequest: PersistenceEffect
{
    public let type: String

    enum CodingKeys: String, CodingKey
    {
        case id
        case type
    }

    public init(type: String)
    {
        self.type = type

        super.init()
    }

    public init(id: UUID, type: String)
    {
        self.type = type

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let type: String = try container.decode(String.self, forKey: .type)

        self.type = type
        super.init(id: id)
    }
}

public class PersistenceCountResponse: PersistenceEvent
{
    public let result: Int

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: Int)
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode(Int.self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceLoadRequest: PersistenceEffect
{
    public let type: String
    public let offset: Int

    enum CodingKeys: String, CodingKey
    {
        case id
        case type
        case offset
    }

    public init(type: String, offset: Int)
    {
        self.type = type
        self.offset = offset

        super.init()
    }

    public init(id: UUID, type: String, offset: Int)
    {
        self.type = type
        self.offset = offset

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let type: String = try container.decode(String.self, forKey: .type)
        let offset: Int = try container.decode(Int.self, forKey: .offset)

        self.type = type
        self.offset = offset
        super.init(id: id)
    }
}

public class PersistenceLoadResponse: PersistenceEvent
{
    public let result: UInt64

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: UInt64)
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode(UInt64.self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceQueryRequest: PersistenceEffect
{
    public let subject: UInt64?
    public let relation: Relation?
    public let object: UInt64?

    enum CodingKeys: String, CodingKey
    {
        case id
        case subject
        case relation
        case object
    }

    public init(subject: UInt64?, relation: Relation?, object: UInt64?)
    {
        self.subject = subject
        self.relation = relation
        self.object = object

        super.init()
    }

    public init(id: UUID, subject: UInt64?, relation: Relation?, object: UInt64?)
    {
        self.subject = subject
        self.relation = relation
        self.object = object

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let subject: UInt64? = try container.decode(UInt64?.self, forKey: .subject)
        let relation: Relation? = try container.decode(Relation?.self, forKey: .relation)
        let object: UInt64? = try container.decode(UInt64?.self, forKey: .object)

        self.subject = subject
        self.relation = relation
        self.object = object
        super.init(id: id)
    }
}

public class PersistenceQueryResponse: PersistenceEvent
{
    public let result: [Relationship]

    enum CodingKeys: String, CodingKey
    {
        case effectId
        case result
    }

    public init(_ effectId: UUID, _ result: [Relationship])
    {
        self.result = result

        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)
        let result = try container.decode([Relationship].self, forKey: .result)

        self.result = result
        super.init(effectId)
    }
}

public class PersistenceSaverelationshipRequest: PersistenceEffect
{
    public let relationship: Relationship

    enum CodingKeys: String, CodingKey
    {
        case id
        case relationship
    }

    public init(relationship: Relationship)
    {
        self.relationship = relationship

        super.init()
    }

    public init(id: UUID, relationship: Relationship)
    {
        self.relationship = relationship

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let relationship: Relationship = try container.decode(Relationship.self, forKey: .relationship)

        self.relationship = relationship
        super.init(id: id)
    }
}

public class PersistenceSaverelationshipResponse: PersistenceEvent
{
    enum CodingKeys: String, CodingKey
    {
        case effectId
    }

    public override init(_ effectId: UUID)
    {
        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)

        super.init(effectId)
    }
}

public class PersistenceDeleterelationshipRequest: PersistenceEffect
{
    public let relationship: Relationship

    enum CodingKeys: String, CodingKey
    {
        case id
        case relationship
    }

    public init(relationship: Relationship)
    {
        self.relationship = relationship

        super.init()
    }

    public init(id: UUID, relationship: Relationship)
    {
        self.relationship = relationship

        super.init(id: id)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let relationship: Relationship = try container.decode(Relationship.self, forKey: .relationship)

        self.relationship = relationship
        super.init(id: id)
    }
}

public class PersistenceDeleterelationshipResponse: PersistenceEvent
{
    enum CodingKeys: String, CodingKey
    {
        case effectId
    }

    public override init(_ effectId: UUID)
    {
        super.init(effectId)
    }

    public required init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let effectId = try container.decode(UUID.self, forKey: .effectId)

        super.init(effectId)
    }
}
