public struct ErrorSuppressingConnector <Converter: ThrowableConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		converter: Converter,
		exporter: E,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ record: Record<Converter.InputMessage, Converter.InputDetails>) {
		let record = record
			.add(identificationInfo)
		
		guard let message = try? converter.convert(record) else { return }
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}
