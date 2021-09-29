public struct AnyExporter <Message>: Exporter {
	public let exporting: (MetaInfo, Message) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <E: Exporter> (_ exporter: E) where E.Message == Message {
		self.identificationInfo = exporter.identificationInfo
		self.exporting = exporter.export
	}
	
	public func export (metaInfo: MetaInfo, message: Message) {
		exporting(metaInfo, message)
	}
}

public extension Exporter {
	func eraseToAnyExporter () -> AnyExporter<Message> {
		AnyExporter(self)
	}
}
