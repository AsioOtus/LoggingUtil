import Foundation

public struct DirectLogger <Connector: LogConnector> {
	public typealias Message = Connector.Message
	public typealias Details = Connector.Details
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var connector: Connector
	
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
}

extension DirectLogger: ConfigurableLogger {
	public func log (level: LogLevel, message: Message, details: Details? = nil) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, labels: [])
		let logRecord = LogRecord(metaInfo: metaInfo, message: message, details: details)
		
		log(logRecord: logRecord)
	}
}

extension DirectLogger: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		connector.log(logRecord)
	}
}
