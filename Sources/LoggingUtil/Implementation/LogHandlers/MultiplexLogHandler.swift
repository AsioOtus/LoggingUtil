class MultiplexLogHandler: ConfigurableLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logHandlers: [AnyLogHandler<Message, Details>]
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		logHandlers: [AnyLogHandler<Message, Details>] = [],
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.logHandlers = logHandlers
	}
	
	func log (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
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
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
