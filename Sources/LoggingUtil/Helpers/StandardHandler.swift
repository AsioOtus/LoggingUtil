import Combine

public typealias StandardHandler<Message: RecordMessage, Details: RecordDetails> = PassthroughSubject<Record<Message, Details>, Never>
