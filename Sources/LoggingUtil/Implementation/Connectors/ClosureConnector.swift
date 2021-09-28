public struct ClosureConnector <Message: Codable, Details: LogRecordDetails>: Connector {
	let connection: (LogRecord<Message, Details>) -> ()
	
	public init (_ connection: @escaping (LogRecord<Message, Details>) -> ()) {
		self.connection = connection
	}
	
	public func log (_ logRecord: LogRecord<Message, Details>) {
		connection(logRecord)
	}
}
