import Foundation

class MultiplexLogHandler: ConfigurableLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logHandlers: [AnyLogHandler<Message, Details>]
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public let identifier: String
	public let label: String
	
	public init (
		logHandlers: [AnyLogHandler<Message, Details>] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		let identifier = UUID().uuidString
		self.identifier = identifier
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line, identifier)
		
		self.logHandlers = logHandlers
	}
	
	func log (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
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
