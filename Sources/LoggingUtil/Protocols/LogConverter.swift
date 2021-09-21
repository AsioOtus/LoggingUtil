public protocol LogConverter { }

public protocol PlainLogConverter: LogConverter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) -> OutputMessage
}

public protocol OptionalLogConverter: LogConverter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) -> OutputMessage?
}

public protocol ThrowableLogConverter: LogConverter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) throws -> OutputMessage
}
