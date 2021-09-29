public struct TransparentConnector <Message: Codable, Details: RecordDetails, E: Exporter>: Connector where E.Message == Record<Message, Details> {
	public let exporter: E
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ exporter: E,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.exporter = exporter
	}
	
	public func log (_ record: Record<Message, Details>) {
		let metaInfo = record.metaInfo
			.add(identificationInfo)
			.add(exporter.identificationInfo)
		let record = record.replace(metaInfo)
		
		exporter.export(metaInfo: record.metaInfo, message: record)
	}
}
