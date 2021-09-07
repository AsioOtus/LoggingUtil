class MultiplexLogHandler: ConfigurableLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logHandlers: [AnyLogHandler<Message, Details>]
	public let label: String
	
	public init (
		logHandlers: [AnyLogHandler<Message, Details>] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.logHandlers = logHandlers
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line)
	}
	
	func log (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		logHandlers.forEach{ $0.log(logRecord: logRecord) }
	}
}

extension MultiplexLogHandler {	
	@discardableResult
	func logHandlers <Handler: LogHandler> (_ logHandlers: Handler) -> Self where Handler.Message == Message, Handler.Details == Details {
		self.logHandlers.append(logHandlers.eraseToAnyLoghandler())
		return self
	}
}
