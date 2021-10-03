public struct PlainConnector <Converter: PlainConverter, E: Exporter>: CustomizableConnector where Converter.OutputMessage == E.Message {
	public typealias Message = Converter.InputMessage
	public typealias Details = Converter.InputDetails
	
	public let converter: Converter
	public let exporter: E
	
	public var filters = [Filter<Message, Details>]()
	
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
	
	public func log (_ record: Record<Message, Details>) {
		guard filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(converter.identificationInfo)
			.add(exporter.identificationInfo)
		
		let message = converter.convert(record)
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}
