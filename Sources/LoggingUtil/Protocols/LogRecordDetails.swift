public protocol LogRecordDetails: Codable {
	associatedtype Enabling: LogRecordDetailsEnabling
	
	func combined (with: Self?) -> Self
	func moderated (_: Enabling) -> Self?
}

public protocol LogRecordDetailsEnabling {
	static var defaultEnabling: Self { get }
	static var fullEnabled: Self { get }
}
