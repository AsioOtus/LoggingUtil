public struct AnyConnector <Message: Codable, Details: LogRecordDetails>: LogConnector {
	public let logging: (LogRecord<Message, Details>) -> Void
	
	public init <Connector: LogConnector> (_ connector: Connector) where Connector.Message == Message, Connector.Details == Details {
		self.logging = connector.log
	}
	
	public func log (_ logRecord: LogRecord<Message, Details>) {
		logging(logRecord)
	}
}
