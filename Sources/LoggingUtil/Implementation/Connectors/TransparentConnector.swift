public struct TransparentConnector <Message: Codable, Details: RecordDetails, E: Exporter>: Connector where E.Message == Record<Message, Details> {
	public let exporter: E
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ exporter: E,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.exporter = exporter
	}
	
	public func log (_ record: Record<Message, Details>) {
		let record = record
			.add(identificationInfo)
		
		exporter.export(metaInfo: record.metaInfo, message: record)
	}
}
