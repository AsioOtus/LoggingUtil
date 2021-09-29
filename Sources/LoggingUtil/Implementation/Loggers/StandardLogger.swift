import Foundation

public struct StandardLogger <H: Handler> {
	public typealias Message = H.Message
	public typealias Details = H.Details
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var handler: H
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handler: H,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.handler = handler
	}
}

extension StandardLogger: ConfigurableLogger {
	public func log (level: Level, message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, label: label, file: file, line: line, stack: [])
		let record = Record(metaInfo: metaInfo, message: message, details: details, configuration: configuration)
		
		log(record: record)
	}
}

extension StandardLogger: Handler {
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.add(configuration)
		
		handler.log(record: record)
	}
}
