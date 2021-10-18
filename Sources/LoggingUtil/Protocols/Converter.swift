public protocol Converter {
	var identificationInfo: IdentificationInfo { get }
}



public protocol OptionalConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: RecordDetails
	associatedtype OutputMessage
	
	func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage?
}



public protocol ThrowableConverter: OptionalConverter {
	func tryConvert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage
}

public extension ThrowableConverter {
	func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage? {
		try? tryConvert(record)
	}
}



public protocol PlainConverter: ThrowableConverter {
	func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage
}

public extension PlainConverter {
	func tryConvert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage {
		convert(record)
	}
}
