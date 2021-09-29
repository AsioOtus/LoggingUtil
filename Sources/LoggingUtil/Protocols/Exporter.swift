public protocol Exporter {
	associatedtype Message
	
	var identificationInfo: IdentificationInfo { get }
	
	func export (metaInfo: MetaInfo, message: Message)
}
