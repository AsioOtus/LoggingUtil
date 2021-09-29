public struct PlainConnector <Converter: PlainConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public var condition: (Record<Message, Details>) -> Bool
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		converter: Converter,
		exporter: E,
		condition: @escaping (Record<Message, Details>) -> Bool = { _ in true },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.converter = converter
		self.exporter = exporter
		
		self.condition = condition
	}
	
	public func log (_ record: Record<Converter.InputMessage, Converter.InputDetails>) {
		guard condition(record) else { return }
		
		let metaInfo = record.metaInfo
			.add(identificationInfo)
			.add(converter.identificationInfo)
			.add(exporter.identificationInfo)
		let record = record.replace(metaInfo)
		
		let message = converter.convert(record)
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}
