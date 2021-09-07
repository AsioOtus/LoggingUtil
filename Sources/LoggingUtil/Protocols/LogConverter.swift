public protocol LogConverter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) -> OutputMessage
}

public protocol OptionalLogConverter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) -> OutputMessage?
}

public protocol ThrowableLogConverter {
	associatedtype InputMessage: Codable
	associatedtype InputDetails: LogRecordDetails
	associatedtype OutputMessage
	
	func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) throws -> OutputMessage
}
