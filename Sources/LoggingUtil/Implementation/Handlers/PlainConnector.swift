public class PlainConnector <Converter: PlainConverter>: Handler {
	public typealias Message = Converter.InputMessage
	public typealias Details = Converter.InputDetails
	
	public let converter: Converter
	public var exporters = [AnyExporter<Converter.OutputMessage>]()
	
	public var filters = [Filter<Message, Details>]()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.converter = converter
	}
	
	public func log (record: Record<Message, Details>) {
		guard filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(converter.identificationInfo)
			.add(exporters.map(\.identificationInfo))
		
		let message = converter.convert(record)
		exporters.forEach { $0.export(metaInfo: record.metaInfo, message: message) }
	}
}

public extension PlainConnector {
	@discardableResult
	func exporter <E: Exporter> (_ exporter: E) -> Self where E.Message == Converter.OutputMessage {
		self.exporters.append(exporter.eraseToAnyExporter())
		return self
	}
	
	@discardableResult
	func exporter (_ exporter: AnyExporter<Converter.OutputMessage>) -> Self {
		self.exporters.append(exporter)
		return self
	}
}
