public struct AnyPlainConverter <Message: Codable, Details: RecordDetails, OutputMessage>: PlainConverter {
    public typealias InputMessage = Message
    public typealias InputDetails = Details
    
    private let converting: (Record<Message, Details>) -> OutputMessage
    
    public init <C: PlainConverter> (_ converter: C)
    where
    C.InputMessage == InputMessage,
    C.InputDetails == InputDetails,
    C.OutputMessage == OutputMessage
    {
        converting = converter.convert
    }
    
    public func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage {
        converting(record)
    }
}

public extension PlainConverter {
    func eraseToAnyPlainConverter () -> AnyPlainConverter<InputMessage, InputDetails, OutputMessage> {
        .init(self)
    }
}
