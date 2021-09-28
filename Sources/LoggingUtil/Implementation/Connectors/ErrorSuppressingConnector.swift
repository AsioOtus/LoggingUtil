public struct ErrorSuppressingConnector <Converter: ThrowableConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public init (converter: Converter, exporter: E) {
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ logRecord: LogRecord<Converter.InputMessage, Converter.InputDetails>) {
		guard let message = try? converter.convert(logRecord) else { return }
		exporter.export(metaInfo: logRecord.metaInfo, message: message)
	}
}
