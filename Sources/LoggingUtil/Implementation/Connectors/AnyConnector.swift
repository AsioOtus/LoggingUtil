public struct AnyConnector <Message: Codable, Details: LogRecordDetails>: Connector {
	public let logging: (LogRecord<Message, Details>) -> Void
	
	public init <C: Connector> (_ connector: C) where C.Message == Message, C.Details == Details {
		self.logging = connector.log
	}
	
	public func log (_ logRecord: LogRecord<Message, Details>) {
		logging(logRecord)
	}
}

extension Connector {
	func eraseToAnyConnector () -> AnyConnector<Message, Details> {
		AnyConnector(self)
	}
}
