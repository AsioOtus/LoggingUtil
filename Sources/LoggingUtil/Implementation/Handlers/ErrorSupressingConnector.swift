public struct ErrorSuppressingConnector <Converter: ThrowableConverter, E: Exporter>: FiltersCustomizable
where Converter.OutputMessage == E.Message
{
	public typealias Message = Converter.InputMessage
	public typealias Details = Converter.InputDetails
	
	public var isEnabled = true
	public var filters = [Filter<Converter.InputMessage, Converter.InputDetails>]()
	
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
}

extension ErrorSuppressingConnector: Handler {
	public func handle (record: Record<Converter.InputMessage, Converter.InputDetails>) {
		let record = record
			.add(identificationInfo)
		
		guard let message = try? converter.convert(record) else { return }
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}

public extension AnyHandler {
	static func supressErrorConnector <Converter: ThrowableConverter, E: Exporter> (
		_ converter: Converter,
		_ exporter: E,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	where Converter.OutputMessage == E.Message
	{
		ErrorSuppressingConnector(
			converter: converter,
			exporter: exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
}
