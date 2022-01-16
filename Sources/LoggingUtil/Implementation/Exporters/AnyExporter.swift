public struct AnyExporter <Message>: Exporter {
	public let exporting: (ExportRecord<Message>) -> Void
	
	public init <E: Exporter> (_ exporter: E) where E.Message == Message {
		self.exporting = exporter.export
	}
	
	public func export (_ record: ExportRecord<Message>) {
		exporting(record)
	}
}

public extension Exporter {
	func eraseToAnyExporter () -> AnyExporter<Message> {
		AnyExporter(self)
	}
}
