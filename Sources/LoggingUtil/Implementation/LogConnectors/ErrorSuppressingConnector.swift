public struct ErrorSuppressingConnector<Converter: ThrowableLogConverter, Exporter: LogExporter>: LogConnector where Converter.OutputMessage == Exporter.Message {
	public let converter: Converter
	public let exporter: Exporter
	
	public init (converter: Converter, exporter: Exporter) {
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ logRecord: LogRecord<Converter.InputMessage, Converter.InputDetails>) {
		guard let message = try? converter.convert(logRecord) else { return }
		exporter.export(metaInfo: logRecord.metaInfo, message: message)
	}
}
