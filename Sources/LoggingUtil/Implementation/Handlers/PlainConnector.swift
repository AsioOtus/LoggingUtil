public class PlainConnector <Converter: PlainConverter>: IsEnabledCustomizable, FiltersCustomizable {
	public typealias Message = Converter.InputMessage
	public typealias Details = Converter.InputDetails
	public typealias ExporterMessage = Converter.OutputMessage
	
	public var isEnabled = true
	public var filters = [Filter<Message, Details>]()
	
	public let converter: Converter
	public var exporters = [AnyExporter<ExporterMessage>]()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		converter: Converter,
		exporters: [AnyExporter<ExporterMessage>],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.converter = converter
		self.exporters = exporters
	}
	
	public convenience init (
		converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		@ArrayBuilder _ exporters: () -> [AnyExporter<ExporterMessage>]
	) {
		self.init(converter: converter, exporters: exporters(), label: label, file: file, line: line)
	}
	
	public convenience init (
		_ converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(converter: converter, exporters: [], label: label, file: file, line: line)
	}
	
	public convenience init <E: Exporter> (
		converter: Converter,
		exporter: E,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	where E.Message == ExporterMessage
	{
		self.init(converter: converter, exporters: [exporter.eraseToAnyExporter()], label: label, file: file, line: line)
	}
	
	public convenience init (
		converter: Converter,
		exporter: AnyExporter<ExporterMessage>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(converter: converter, exporters: [exporter], label: label, file: file, line: line)
	}
}

extension PlainConnector: Handler {
	public func handle (record: Record<Message, Details>) {
		guard isEnabled, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(converter.identificationInfo)
		
		for exporter in exporters {
			let record = record
				.add(exporters.map(\.identificationInfo))
			
			let message = converter.convert(record)
			exporter.export(metaInfo: record.metaInfo, message: message)
		}
	}
}

public extension PlainConnector {
	@discardableResult
	func exporter <E: Exporter> (_ exporter: E) -> Self where E.Message == ExporterMessage {
		self.exporters.append(exporter.eraseToAnyExporter())
		return self
	}
	
	@discardableResult
	func exporter (_ exporter: AnyExporter<ExporterMessage>) -> Self {
		self.exporters.append(exporter)
		return self
	}
	
	@discardableResult
	func exporters (@ArrayBuilder _ exporters: () -> [AnyExporter<ExporterMessage>]) -> Self {
		self.exporters.append(contentsOf: exporters())
		return self
	}
}

public extension AnyHandler {
	static func plainConnector <Converter: PlainConverter> (
		converter: Converter,
		exporters: [AnyExporter<Converter.OutputMessage>],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	{
		PlainConnector(
			converter: converter,
			exporters: exporters,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func plainConnector <Converter: PlainConverter> (
		_ converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	{
		PlainConnector(
			converter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func plainConnector <Converter: PlainConverter, E: Exporter> (
		converter: Converter,
		exporter: E,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	where E.Message == Converter.OutputMessage
	{
		PlainConnector(
			converter: converter,
			exporter: exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func plainConnector <Converter: PlainConverter> (
		converter: Converter,
		exporter: AnyExporter<Converter.OutputMessage>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	{
		PlainConnector(
			converter: converter,
			exporter: exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
}
