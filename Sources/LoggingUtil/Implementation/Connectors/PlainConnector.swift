public struct PlainConnector <Converter: PlainConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public var filter: Filter<Message, Details>
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		converter: Converter,
		exporter: E,
		filter: @escaping Filter<Message, Details> = { _ in true },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.converter = converter
		self.exporter = exporter
		
		self.filter = filter
	}
	
	public func log (_ record: Record<Converter.InputMessage, Converter.InputDetails>) {
		guard filter(record) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(converter.identificationInfo)
			.add(exporter.identificationInfo)
		
		let message = converter.convert(record)
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}
