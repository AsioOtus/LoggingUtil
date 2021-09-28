public protocol Connector {
	associatedtype Message: Codable
	associatedtype Details: LogRecordDetails
	
	func log (_ logRecord: LogRecord<Message, Details>)
}
