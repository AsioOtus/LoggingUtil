public protocol RecordDetails: Codable {
	associatedtype Enabling: RecordDetailsEnabling
	
	func combined (with: Self) -> Self
	func moderated (_: Enabling) -> Self?
}



public protocol RecordDetailsEnabling {
	static var defaultEnabling: Self { get }
	static var fullEnabled: Self { get }
    static var fullDisabled: Self { get }
}



extension Bool: RecordDetailsEnabling {
    public static var defaultEnabling: Self { true }
    public static var fullEnabled: Self { true }
    public static var fullDisabled: Self { false }
}
