public struct EmptyExporter <Message: Codable>: Exporter {
	public init () { }
	
	public func export (metaInfo: MetaInfo, message: Message) { }
}
