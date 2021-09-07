public class StandardLogHandler<Connector: LogConnector>: ConfigurableLogHandler {
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var connector: Connector
	public let label: String
	
	public init (
		connector: Connector,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.connector = connector
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line)
	}

	public func log (logRecord: LogRecord<Connector.Message, Connector.Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		connector.log(logRecord)
	}
}
