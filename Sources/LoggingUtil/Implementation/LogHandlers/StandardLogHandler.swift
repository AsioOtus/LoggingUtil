import Foundation

public class StandardLogHandler<Connector: LogConnector>: ConfigurableLogHandler {
	public typealias Message = Connector.Message
	public typealias Details = Connector.Details
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var connector: Connector
	public var detailsEnabling: Details.Enabling = .defaultEnabling
	public let identifier: String
	public let label: String
	
	public init (
		connector: Connector,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		let identifier = UUID().uuidString
		self.identifier = identifier
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line, identifier)
		
		self.connector = connector
	}

	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		connector.log(logRecord)
	}
}

extension StandardLogHandler {
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
