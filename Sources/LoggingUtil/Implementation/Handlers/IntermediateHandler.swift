public class IntermediateHandler<H: Handler>: ConfigurableHandler {
	public typealias Message = H.Message
	public typealias Details = H.Details
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var handler: H
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handler: H,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
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

extension IntermediateHandler {
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
