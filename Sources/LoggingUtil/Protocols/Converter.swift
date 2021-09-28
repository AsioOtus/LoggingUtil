public protocol Converter { }

public protocol PlainConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: RecordDetails
	associatedtype OutputMessage
	
	func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage
}

public protocol OptionalConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: RecordDetails
	associatedtype OutputMessage
	
	func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage?
}

public protocol ThrowableConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: RecordDetails
	associatedtype OutputMessage
	
	func convert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage
}
