public struct AnyExporter <Message>: Exporter {
	public let exporting: (MetaInfo, Message) -> Void
	
	public init <E: Exporter> (_ exporter: E) where E.Message == Message {
		self.exporting = exporter.export
	}
	
	public func export (metaInfo: MetaInfo, message: Message) {
		exporting(metaInfo, message)
	}
}

extension Exporter {
	func eraseToAnyExporter () -> AnyExporter<Message> {
		AnyExporter(self)
	}
}
