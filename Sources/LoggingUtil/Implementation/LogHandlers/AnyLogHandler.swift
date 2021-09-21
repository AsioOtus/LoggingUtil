public struct AnyLogHandler<Message: Codable, Details: LogRecordDetails>: LogHandler {
	public let logging: (LogRecord<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <Handler: LogHandler> (_ logHandler: Handler) where Handler.Message == Message, Handler.Details == Details {
		self.identificationInfo = logHandler.identificationInfo
		self.logging = logHandler.log
	}
	
	public func log (logRecord: LogRecord<Message, Details>) {
		logging(logRecord)
	}
}
