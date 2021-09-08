public class MultiplexConnectorsLogHandler: ConfigurableLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	
	public var connectors: [AnyConnector<Message, Details>]
	public let label: String
	
	public init (
		connectors: [AnyConnector<Message, Details>] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.connectors = connectors
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line)
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		connectors.forEach{ $0.log(logRecord) }
	}
}

extension MultiplexConnectorsLogHandler {	
	@discardableResult
	func connector <Connector: LogConnector> (_ connector: Connector) -> Self where Connector.Message == Message, Connector.Details == Details {
		self.connectors.append(connector.eraseToAnyConnector())
		return self
	}
}