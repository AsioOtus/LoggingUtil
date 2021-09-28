public struct ThrowableClosureConverter <InputMessage: Codable, InputDetails: RecordDetails, OutputMessage>: ThrowableConverter {
	let conversion: (Record<InputMessage, InputDetails>) throws -> OutputMessage
	
	public init (conversion: @escaping (Record<InputMessage, InputDetails>) throws -> OutputMessage) {
		self.conversion = conversion
	}
	
	public func convert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage {
		try conversion(record)
	}
}
