public class TransparentLogHandler<Handler: LogHandler>: ConfigurableLogHandler {
	public typealias Message = Handler.Message
	public typealias Details = Handler.Details
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var handler: Handler
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handler: Handler,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.handler = handler
	}
	
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		handler.log(logRecord: logRecord)
	}
}

extension TransparentLogHandler {
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
