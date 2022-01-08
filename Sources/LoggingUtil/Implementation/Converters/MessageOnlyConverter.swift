public struct MessageOnlyConverter <Message: RecordMessage, Details: RecordDetails>: PlainConverter {
	public typealias InputMessage = Message
	public typealias InputDetails = Details
	public typealias OutputMessage = Message
	
    public init () { }
	
	public func convert (_ record: Record<InputMessage, InputDetails>) -> InputMessage { record.message }
}

public extension AnyPlainConverter {
    static var messageOnlyConverter: AnyPlainConverter<InputMessage, InputDetails, InputMessage> {
        MessageOnlyConverter().eraseToAnyPlainConverter()
    }
}
