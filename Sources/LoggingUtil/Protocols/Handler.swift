public protocol Handler: IsEnabledCustomizable {
	associatedtype Message: Codable
	associatedtype Details: RecordDetails
	
	var identificationInfo: IdentificationInfo { get }
	
	func handle (record: Record<Message, Details>)
}
