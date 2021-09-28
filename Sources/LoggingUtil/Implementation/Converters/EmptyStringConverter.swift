public struct EmptyStringConverter: PlainConverter {
	public init () { }
	
	public func convert (_ logRecord: LogRecord<String, StandardLogRecordDetails>) -> String { "" }
}
