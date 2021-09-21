import Foundation

public class MultiplexConnectorsLogHandler: ConfigurableLogHandler {
	public typealias Message = String
	public typealias Details = StandardLogRecordDetails
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var connectors: [AnyConnector<Message, Details>]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		connectors: [AnyConnector<Message, Details>] = [],
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.connectors = connectors
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
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
