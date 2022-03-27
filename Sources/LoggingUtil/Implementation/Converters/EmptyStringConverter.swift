public struct EmptyStringConverter <Message: RecordMessage, Details: RecordDetails>: PlainConverter {
    public typealias InputMessage = Message
    public typealias InputDetails = Details
    public typealias OutputMessage = String
	
    public init () { }
	
	public func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage { "" }
}

public extension AnyPlainConverter {
	static var emptyStringConverter: AnyPlainConverter<InputMessage, InputDetails, String> {
		EmptyStringConverter().eraseToAnyPlainConverter()
	}
}
