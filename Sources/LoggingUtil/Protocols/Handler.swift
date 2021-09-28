public protocol Handler {
	associatedtype Message: Codable
	associatedtype Details: LogRecordDetails
	
	var identificationInfo: IdentificationInfo { get }
	
	func log (logRecord: LogRecord<Message, Details>)
}
