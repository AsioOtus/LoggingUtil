import Foundation

public class MultiplexConnectorsLogHandler: ConfigurableLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var connectors: [AnyConnector<Message, Details>]
	public let label: String
	public let identifier: String
	
	public init (
		connectors: [AnyConnector<Message, Details>] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		let identifier = UUID().uuidString
		self.identifier = identifier
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line, identifier)
		
		self.connectors = connectors
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
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
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
