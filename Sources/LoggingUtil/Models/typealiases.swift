import Combine

public typealias StandardHandler<Message: RecordMessage, Details: RecordDetails> = PassthroughSubject<Record<Message, Details>, Never>
public typealias StandardOutput<Message: RecordMessage, Details: RecordDetails> = AnyPublisher<Record<Message, Details>, Never>
