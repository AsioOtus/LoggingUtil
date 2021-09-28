import Foundation

public struct DirectLogger <C: Connector> {
	public typealias Message = C.Message
	public typealias Details = C.Details
	
	public var isEnabled = true
	public var level = Level.trace
	public var details: Details? = nil
	public var connector: C
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		connector: C,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.connector = connector
	}
}

extension DirectLogger: ConfigurableLogger {
	public func log (level: Level, message: Message, details: Details? = nil) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, stack: [])
		let logRecord = LogRecord(metaInfo: metaInfo, message: message, details: details)
		
		log(logRecord: logRecord)
	}
}

extension DirectLogger: Handler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		connector.log(logRecord)
	}
}
