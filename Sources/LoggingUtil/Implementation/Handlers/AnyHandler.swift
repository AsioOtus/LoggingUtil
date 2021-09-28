public struct AnyHandler <Message: Codable, Details: RecordDetails>: Handler {
	public let logging: (Record<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <H: Handler> (_ handler: H) where H.Message == Message, H.Details == Details {
		self.identificationInfo = handler.identificationInfo
		self.logging = handler.log
	}
	
	public func log (record: Record<Message, Details>) {
		logging(record)
	}
}

extension Handler {
	func eraseToAnyHandler () -> AnyHandler<Message, Details> {
		AnyHandler(self)
	}
}
