import Foundation

public struct StandardLogger <Handler: LogHandler> {
	public typealias Message = Handler.Message
	public typealias Details = Handler.Details
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var logHandler: Handler
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		logHandler: Handler,
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(typeId: String(describing: Self.self), file: file, line: line, alias: alias)
		
		self.logHandler = logHandler
	}
}

extension StandardLogger: ConfigurableLogger {
	public func log (level: LogLevel, message: Message, details: Details? = nil) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, stack: [])
		let logRecord = LogRecord(metaInfo: metaInfo, message: message, details: details)
		
		log(logRecord: logRecord)
	}
}

extension StandardLogger: LogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = logRecord.details?.combined(with: self.details) ?? self.details
		let logRecord = logRecord.replace(metaInfo, details)
		
		logHandler.log(logRecord: logRecord)
	}
}
