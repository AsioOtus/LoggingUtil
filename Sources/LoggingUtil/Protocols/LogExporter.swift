public protocol LogExporter {
	associatedtype Message
	
	func export (metaInfo: MetaInfo, message: Message)
}
