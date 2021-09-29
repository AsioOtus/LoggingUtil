public protocol Connector {
	associatedtype Message: Codable
	associatedtype Details: RecordDetails
	
	var identificationInfo: IdentificationInfo { get }
	
	func log (_ record: Record<Message, Details>)
}
