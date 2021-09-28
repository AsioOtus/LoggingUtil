public struct EmptyStringConverter: PlainConverter {
	public init () { }
	
	public func convert (_ record: Record<String, StandardRecordDetails>) -> String { "" }
}
