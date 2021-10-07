public protocol Handler {
	associatedtype Message: Codable
	associatedtype Details: RecordDetails
	
	var identificationInfo: IdentificationInfo { get }
	
	func handle (record: Record<Message, Details>)
}
