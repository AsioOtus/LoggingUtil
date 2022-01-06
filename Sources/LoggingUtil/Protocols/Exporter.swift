public protocol Exporter {
	associatedtype Message
    
	func export (metaInfo: MetaInfo, message: Message)
}
