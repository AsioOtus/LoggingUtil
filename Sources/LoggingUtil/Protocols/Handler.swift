public protocol Handler {
	associatedtype Message: Codable
	associatedtype Details: RecordDetails
	
	var identificationInfo: IdentificationInfo { get }
	
	func log (record: Record<Message, Details>)
}
