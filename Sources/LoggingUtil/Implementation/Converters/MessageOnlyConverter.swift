public struct MessageOnlyConverter <Message: Codable, Details: RecordDetails>: PlainConverter {
	public init () { }
	
	public func convert (_ record: Record<Message, Details>) -> Message { record.message }
}
