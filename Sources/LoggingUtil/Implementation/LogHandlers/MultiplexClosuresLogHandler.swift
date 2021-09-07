public class MultiplexClosuresLogHandler<Message: Codable, Details: LogRecordDetails>: ConfigurableLogHandler {
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	
	public var handlings: [(LogRecord<Message, Details>) -> ()]
	public let label: String
	
	public init (
		handlings: [(LogRecord<Message, Details>) -> ()] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.handlings = handlings
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line)
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		handlings.forEach{ $0(logRecord) }
	}
}

extension MultiplexClosuresLogHandler {
	@discardableResult
	func handling (_ handling: @escaping (LogRecord<Message, Details>) -> ()) -> Self {
		self.handlings.append(handling)
		return self
	}
}
