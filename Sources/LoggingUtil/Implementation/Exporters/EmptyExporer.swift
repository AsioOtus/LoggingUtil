struct EmptyExporter <Message: Codable>: Exporter {
	public init () { }
	
	func export (metaInfo: MetaInfo, message: Message) { }
}
