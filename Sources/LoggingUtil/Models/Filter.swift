public typealias Filter<Message: Codable, Details: RecordDetails> = (Record<Message, Details>) -> Bool
