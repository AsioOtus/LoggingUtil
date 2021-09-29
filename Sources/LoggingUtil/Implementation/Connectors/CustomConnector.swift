public struct CustomConnector <Message: Codable, Details: RecordDetails>: Connector {
	let connection: (Record<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		alias: String? = nil,
		file: String = #file,
		line: Int = #line,
		_ connection: @escaping (Record<Message, Details>) -> Void
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.connection = connection
	}
	
	public func log (_ record: Record<Message, Details>) {
		let metaInfo = record.metaInfo.add(identificationInfo)
		let record = record.replace(metaInfo)
		
		connection(record)
	}
}
