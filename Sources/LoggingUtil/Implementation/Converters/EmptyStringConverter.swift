import Combine

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

public extension Publisher {
	func emptyString <Message, Details> () -> Publishers.Map<Self, ExportRecord<String>>
	where
	Output == Record<Message, Details>,
	Failure == Never
	{
		convert(.emptyStringConverter)
	}
}
