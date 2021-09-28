public protocol Converter { }

public protocol PlainConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) -> OutputMessage
}

public protocol OptionalConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) -> OutputMessage?
}

public protocol ThrowableConverter: Converter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) throws -> OutputMessage
}
