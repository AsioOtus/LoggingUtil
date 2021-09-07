public struct ThrowableClosureConverter <InputMessage: Codable, InputDetails: LogRecordDetails, OutputMessage>: ThrowableLogConverter {
	let conversion: (LogRecord<InputMessage, InputDetails>) throws -> OutputMessage
	
	public init (conversion: @escaping (LogRecord<InputMessage, InputDetails>) throws -> OutputMessage) {
		self.conversion = conversion
	}
	
	public func convert (_ logRecord: LogRecord<InputMessage, InputDetails>) throws -> OutputMessage {
		try conversion(logRecord)
	}
}
