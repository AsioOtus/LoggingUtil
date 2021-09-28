public class MultipleClosuresHandler <Message: Codable, Details: LogRecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var handlings: [(LogRecord<Message, Details>) -> ()]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handlings: [(LogRecord<Message, Details>) -> ()] = [],
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.handlings = handlings
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = logRecord.details?.combined(with: self.details) ?? self.details?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		handlings.forEach{ $0(logRecord) }
	}
}

extension MultipleClosuresHandler {
	@discardableResult
	func handling (_ handling: @escaping (LogRecord<Message, Details>) -> ()) -> Self {
		self.handlings.append(handling)
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
