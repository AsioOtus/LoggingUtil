public struct AnyHandler <Message: Codable, Details: RecordDetails>: Handler {
	public var isEnabled: Bool
	
	public let logging: (Record<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <H: Handler> (_ handler: H) where H.Message == Message, H.Details == Details {
		self.identificationInfo = handler.identificationInfo
		self.logging = handler.handle
		self.isEnabled = handler.isEnabled
	}
	
	public func handle (record: Record<Message, Details>) {
		guard isEnabled else { return }
		
		logging(record)
	}
}

public extension Handler {
	func eraseToAnyHandler () -> AnyHandler<Message, Details> {
		AnyHandler(self)
	}
}
