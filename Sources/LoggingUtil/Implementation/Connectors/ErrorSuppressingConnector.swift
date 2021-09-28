public struct ErrorSuppressingConnector <Converter: ThrowableConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public init (converter: Converter, exporter: E) {
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ record: Record<Converter.InputMessage, Converter.InputDetails>) {
		guard let message = try? converter.convert(record) else { return }
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}
