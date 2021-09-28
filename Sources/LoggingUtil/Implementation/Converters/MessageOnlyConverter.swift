public struct MessageOnlyConverter <Message: Codable, Details: LogRecordDetails>: PlainConverter {
	public init () { }
	
	public func convert (_ logRecord: LogRecord<Message, Details>) -> Message { logRecord.message }
}
