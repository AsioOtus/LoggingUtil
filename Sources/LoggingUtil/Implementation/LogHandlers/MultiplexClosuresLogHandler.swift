public class MultiplexClosuresLogHandler<Message: Codable, Details: LogRecordDetails> {	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logHandlers: [(LogRecord<Message, Details>) -> ()]
	public let label: String
	
	public init (
		logHandlers: [(LogRecord<Message, Details>) -> ()] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.logHandlers = logHandlers
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line)
	}
}

extension MultiplexClosuresLogHandler: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		logHandlers.forEach{ $0(logRecord) }
	}
}

extension MultiplexClosuresLogHandler {
	@discardableResult
	public func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
	
	@discardableResult
	public func level (_ level: LogLevel) -> Self {
		self.level = level
		return self
	}
	
	@discardableResult
	public func details (_ details: Details) -> Self {
		self.details = details
		return self
	}
	
	@discardableResult
	func logHandler (_ logHandler: @escaping (LogRecord<Message, Details>) -> ()) -> Self {
		self.logHandlers.append(logHandler)
		return self
	}
}
