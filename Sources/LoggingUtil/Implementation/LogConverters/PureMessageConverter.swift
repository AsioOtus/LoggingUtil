public struct PureMessageConverter<Message: Codable, Details: LogRecordDetails>: LogConverter {
	public func convert (_ logRecord: LogRecord<Message, Details>) -> Message { return logRecord.message }
}
