import Combine

public typealias StandardOutput<Message: RecordMessage, Details: RecordDetails> = AnyPublisher<Record<Message, Details>, Never>
