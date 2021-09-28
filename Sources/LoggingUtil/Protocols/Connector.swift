public protocol Connector {
	associatedtype Message: Codable
	associatedtype Details: RecordDetails
	
	func log (_ record: Record<Message, Details>)
}
