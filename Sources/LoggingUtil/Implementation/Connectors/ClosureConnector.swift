public struct ClosureConnector <Message: Codable, Details: RecordDetails>: Connector {
	let connection: (Record<Message, Details>) -> ()
	
	public init (_ connection: @escaping (Record<Message, Details>) -> ()) {
		self.connection = connection
	}
	
	public func log (_ record: Record<Message, Details>) {
		connection(record)
	}
}
