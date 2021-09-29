import Foundation

public struct StandardLogger <H: Handler> {
	public typealias Message = H.Message
	public typealias Details = H.Details
	
	public var isEnabled = true
	public var level: Level = .trace
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
		let record = Record(metaInfo: metaInfo, message: message, details: details)
		
		log(record: record)
	}
}

extension StandardLogger: Handler {
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = record.details?.combined(with: self.details) ?? self.details
		let record = record.replace(metaInfo, details)
		
		handler.log(record: record)
	}
}
