public struct PlainConnector <Converter: PlainConverter, E: Exporter>: Connector where Converter.OutputMessage == E.Message {
	public let converter: Converter
	public let exporter: E
	
	public init (converter: Converter, exporter: E) {
		self.converter = converter
		self.exporter = exporter
	}
	
	public func log (_ record: Record<Converter.InputMessage, Converter.InputDetails>) {
		let message = converter.convert(record)
		exporter.export(metaInfo: record.metaInfo, message: message)
	}
}
