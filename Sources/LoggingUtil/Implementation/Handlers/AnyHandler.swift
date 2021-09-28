public struct AnyHandler <Message: Codable, Details: LogRecordDetails>: Handler {
	public let logging: (LogRecord<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <H: Handler> (_ handler: H) where H.Message == Message, H.Details == Details {
		self.identificationInfo = handler.identificationInfo
		self.logging = handler.log
	}
	
	public func log (logRecord: LogRecord<Message, Details>) {
		logging(logRecord)
	}
}

extension Handler {
	func eraseToAnyHandler () -> AnyHandler<Message, Details> {
		AnyHandler(self)
	}
}
