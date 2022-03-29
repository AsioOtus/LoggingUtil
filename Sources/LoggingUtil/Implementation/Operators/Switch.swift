import Combine

public extension Publisher {
    @discardableResult
    func `switch` <Message, Details> (_ cases: (Switch<Self, Message, Details>) -> Void) -> Self
    where Output == Record<Message, Details>, Failure == Never
    {
        cases(Switch<Self, Message, Details>(self.eraseToAnyPublisher()))
        return self
    }
}

extension Switch {
    public struct Key: ExpressibleByStringLiteral, Equatable {
        public let value: String
        
        public init (stringLiteral value: StringLiteralType) {
            self.value = value
        }
    }
}

public final class Switch <P: Publisher, Message: RecordMessage, Details: RecordDetails> where P.Output == Record<Message, Details>, P.Failure == Never {
    private let publisher: AnyPublisher<Record<Message, Details>, Never>
    private var keys = [Key]()
    
    init (_ publisher: AnyPublisher<Record<Message, Details>, Never>) {
        self.publisher = publisher
    }
    
    @discardableResult
    public func `case` (_ key: Key, _ handler: (AnyPublisher<Record<Message, Details>, Never>) -> Void) -> Self {
        keys.append(key)
        
        let casePublisher = publisher
            .filter { ($0.configuration?.keyValue[.switch] as? Key) == key }
            .eraseToAnyPublisher()
		
        handler(casePublisher)
        
        return self
    }
    
    @discardableResult
    public func `default` (_ handler: (AnyPublisher<Record<Message, Details>, Never>) -> Void) -> Self {
        let defaultPublisher = publisher
            .filter { $0.configuration?.keyValue[.switch] == nil }
            .eraseToAnyPublisher()
		
        handler(defaultPublisher)
        
        return self
    }
    
    @discardableResult
    public func unknown (_ handler: (AnyPublisher<Record<Message, Details>, Never>) -> Void) -> Self {
        let defaultPublisher = publisher
            .filter { ($0.configuration?.keyValue[.switch] as? Key).map { !self.keys.contains($0) } ?? false }
            .eraseToAnyPublisher()
        
        handler(defaultPublisher)
        
        return self
    }
}

public extension Configuration.Key {
    static var `switch`: Self { "switch" }
}
