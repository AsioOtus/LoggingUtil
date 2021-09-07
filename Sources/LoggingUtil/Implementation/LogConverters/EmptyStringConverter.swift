public struct EmptyStringConverter: LogConverter {
	public func convert (_ logRecord: LogRecord<String, StandardLogRecordDetails>) -> String { return "" }
}
