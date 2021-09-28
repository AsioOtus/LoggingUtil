public struct PlainConnector <Converter: PlainConverter, Exporter: LogExporter>: Connector where Converter.OutputMessage == Exporter.Message {
	public let converter: Converter
	public let exporter: Exporter
	
	public init (converter: Converter, exporter: Exporter) {
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ logRecord: LogRecord<Converter.InputMessage, Converter.InputDetails>) {
		let message = converter.convert(logRecord)
		exporter.export(metaInfo: logRecord.metaInfo, message: message)
	}
}
