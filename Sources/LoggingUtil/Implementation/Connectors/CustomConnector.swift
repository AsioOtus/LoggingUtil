public struct CustomConnector <Message: Codable, Details: RecordDetails>: Connector {
	let connection: (Record<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #file,
		line: Int = #line,
		_ connection: @escaping (Record<Message, Details>) -> Void
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.connection = connection
	}
	
	public func log (_ record: Record<Message, Details>) {
		let record = record
			.add(identificationInfo)
		
		connection(record)
	}
}
