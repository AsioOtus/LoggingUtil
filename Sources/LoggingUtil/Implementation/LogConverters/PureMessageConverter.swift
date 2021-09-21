public struct PureMessageConverter<Message: Codable, Details: LogRecordDetails>: PlainLogConverter {
	public func convert (_ logRecord: LogRecord<Message, Details>) -> Message { return logRecord.message }
}
