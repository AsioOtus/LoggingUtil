public protocol LogConnector {
	associatedtype Message: Codable
	associatedtype Details: LogRecordDetails
	
	func log (_ logRecord: LogRecord<Message, Details>)
}

extension LogConnector {
	func eraseToAnyConnector () -> AnyConnector<Message, Details> {
		AnyConnector(self)
	}
}
