import Combine

public extension Publisher {
    func `switch` <Message, Details> (_ cases: (Switch) -> Void) -> AnyPublisher<Output, Failure> where Output == Record<Message, Details>, Failure == Never {
        cases(Switch<Message, Details>())
        return filter { _ in true }.eraseToAnyPublisher()
    }
}

public final class Switch <Message: Codable, Details: RecordDetails> {
    private let publisher: AnyPublisher<Record<Message, Details>, Never>
    
    init (_ publisher: AnyPublisher<Record<Message, Details>, Never>) {
        self.publisher = publisher
    }
    
    public func `case` (_ key: String, _ handler: (AnyPublisher<Record<Message, Details>, Never>) -> Void) -> Self {
        handler(publisher.filter { record in record.configuration?.keyValue[] })
        return self
    }
}
