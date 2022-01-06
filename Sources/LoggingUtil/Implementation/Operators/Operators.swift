import Combine

extension Publisher {
    func details <Message, Details: RecordDetails> (_ details: Details) -> AnyPublisher<Output, Failure> where Output == Record<Message, Details>, Failure == Never {
        map { $0.add(details) }.eraseToAnyPublisher()
    }
    
    func configuration <Message, Details> (_ configuration: Configuration) -> AnyPublisher<Output, Failure> where Output == Record<Message, Details>, Failure == Never {
        map { $0.add(configuration) }.eraseToAnyPublisher()
    }
    
    func level <Message, Details> (_ level: Level) -> AnyPublisher<Output, Failure> where Output == Record<Message, Details>, Failure == Never {
        filter { $0.metaInfo.level >= level }.eraseToAnyPublisher()
    }
    
    func isEnabled <Message, Details> (_ isEnabled: Bool = true) -> AnyPublisher<Output, Failure> where Output == Record<Message, Details>, Failure == Never {
        filter { _ in isEnabled }.eraseToAnyPublisher()
    }
}
