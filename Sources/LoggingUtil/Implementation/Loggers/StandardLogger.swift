import Foundation

public struct StandardLogger <H: Handler> {
	public typealias Message = H.Message
	public typealias Details = H.Details
	
	public var isEnabled = true
	public var level = Level.trace
	public var details: Details? = nil
	public var handler: H
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handler: H,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.handler = handler
	}
}

extension StandardLogger: ConfigurableLogger {
	public func log (level: Level, message: Message, details: Details? = nil) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, stack: [])
		let logRecord = LogRecord(metaInfo: metaInfo, message: message, details: details)
		
		log(logRecord: logRecord)
	}
}

extension StandardLogger: Handler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		handler.log(logRecord: logRecord)
	}
}
