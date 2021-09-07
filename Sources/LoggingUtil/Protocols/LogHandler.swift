public protocol LogHandler {
	associatedtype Message: Codable
	associatedtype Details: LogRecordDetails
	
	func log (logRecord: LogRecord<Message, Details>)
}

extension LogHandler {
	func eraseToAnyLoghandler () -> AnyLogHandler<Message, Details> {
		AnyLogHandler(self)
	}
}
