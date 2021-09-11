public class ClosureLogHandler<Message: Codable, Details: LogRecordDetails>: ConfigurableLogHandler {
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var handling: (LogRecord<Message, Details>) -> ()
	public let label: String
	public var detailsEnabling: Details.Enabling = .defaultEnabling
	
	public init (
		handling: @escaping (LogRecord<Message, Details>) -> () = { _ in },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.handling = handling
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line)
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		handling(logRecord)
	}
}

extension ClosureLogHandler {
	@discardableResult
	func handling (_ logHandler: @escaping (LogRecord<Message, Details>) -> ()) -> Self {
		self.handling = handling
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
