public struct EmptyStringConverter: PlainLogConverter {
	public func convert (_ logRecord: LogRecord<String, StandardLogRecordDetails>) -> String { return "" }
}
