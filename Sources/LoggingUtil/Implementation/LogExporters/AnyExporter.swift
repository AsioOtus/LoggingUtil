public struct AnyExporter <Message>: LogExporter {
	public let exporting: (MetaInfo, Message) -> Void
	
	public init <Exporter: LogExporter> (_ exporter: Exporter) where Exporter.Message == Message {
		self.exporting = exporter.export
	}
	
	public func export (metaInfo: MetaInfo, message: Message) {
		exporting(metaInfo, message)
	}
}
