public struct PlainConnector <Converter: PlainConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public init (converter: Converter, exporter: E) {
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ logRecord: LogRecord<Converter.InputMessage, Converter.InputDetails>) {
		let message = converter.convert(logRecord)
		exporter.export(metaInfo: logRecord.metaInfo, message: message)
	}
}
