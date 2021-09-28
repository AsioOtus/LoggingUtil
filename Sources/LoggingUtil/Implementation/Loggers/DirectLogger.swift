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
		let record = Record(metaInfo: metaInfo, message: message, details: details)
		
		log(record: record)
	}
}

extension DirectLogger: Handler {
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = record.details?.combined(with: self.details) ?? self.details
		let record = record.replace(metaInfo, details)
		
		connector.log(record)
	}
}
