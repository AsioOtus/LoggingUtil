struct EmptyExporter<Message: Codable>: LogExporter {
	func export(metaInfo: MetaInfo, message: Message) { }
}
