public struct AnyThrowableConverter <Message: Codable, Details: RecordDetails, OutputMessage>: ThrowableConverter {
    public typealias InputMessage = Message
    public typealias InputDetails = Details
    
    private let converting: (Record<Message, Details>) throws -> OutputMessage
    
    public init <C: ThrowableConverter> (_ converter: C)
    where
    C.InputMessage == InputMessage,
    C.InputDetails == InputDetails,
    C.OutputMessage == OutputMessage
    {
        converting = converter.tryConvert
    }
    
    public func tryConvert(_ record: Record<Message, Details>) throws -> OutputMessage {
        try converting(record)
    }
}

public extension ThrowableConverter {
    func eraseToAnyThrowableConverter () -> AnyThrowableConverter<InputMessage, InputDetails, OutputMessage> {
        .init(self)
    }
}

public extension PlainConverter {
    func eraseToAnyThrowableConverter () -> AnyThrowableConverter<InputMessage, InputDetails, OutputMessage> {
        .init(self)
    }
}
