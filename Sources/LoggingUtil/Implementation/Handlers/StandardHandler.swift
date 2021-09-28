public class StandardHandler <C: Connector>: ConfigurableHandler {
	public typealias Message = C.Message
	public typealias Details = C.Details
	
	public var isEnabled = true
	public var level: LogLevel = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var connector: C
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		connector: C,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		self.connector = connector
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		connector.log(logRecord)
	}
}

extension StandardHandler {
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
