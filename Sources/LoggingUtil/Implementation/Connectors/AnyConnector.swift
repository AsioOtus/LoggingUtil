public struct AnyConnector <Message: Codable, Details: RecordDetails>: Connector {
	public let logging: (Record<Message, Details>) -> Void
	
	public init <C: Connector> (_ connector: C) where C.Message == Message, C.Details == Details {
		self.logging = connector.log
	}
	
	public func log (_ record: Record<Message, Details>) {
		logging(record)
	}
}

extension Connector {
	func eraseToAnyConnector () -> AnyConnector<Message, Details> {
		AnyConnector(self)
	}
}
