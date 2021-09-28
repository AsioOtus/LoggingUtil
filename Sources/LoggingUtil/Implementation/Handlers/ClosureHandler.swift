public class ClosureHandler <Message: Codable, Details: LogRecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: LogLevel = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var handling: (LogRecord<Message, Details>) -> ()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handling: @escaping (LogRecord<Message, Details>) -> () = { _ in },
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		self.handling = handling
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		handling(logRecord)
	}
}

extension ClosureHandler {
	@discardableResult
	func handling (_ handling: @escaping (LogRecord<Message, Details>) -> ()) -> Self {
		self.handling = handling
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
