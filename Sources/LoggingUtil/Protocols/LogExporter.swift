public protocol LogExporter {
	associatedtype Message
	
	func export (metaInfo: MetaInfo, message: Message)
}

extension LogExporter {
	func eraseToAnyExporter () -> AnyExporter<Message> {
		AnyExporter(self)
	}
}
