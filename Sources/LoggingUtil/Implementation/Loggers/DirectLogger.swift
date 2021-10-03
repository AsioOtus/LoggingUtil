import Foundation

public struct DirectLogger <C: Connector> {
	public typealias Message = C.Message
	public typealias Details = C.Details
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var connector: C
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ connector: C,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.connector = connector
	}
}

extension DirectLogger: CustomizableLogger {
	public func log (level: Level, message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String?, file: String = #fileID, line: Int = #line) {
		let metaInfo = MetaInfo(timestamp: Date().timeIntervalSince1970, level: level, label: label, file: file, line: line, stack: [])
		let record = Record(metaInfo: metaInfo, message: message, details: details, configuration: configuration)
		
		log(record: record)
	}
}

extension DirectLogger: Handler {
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.add(configuration)
		
		connector.log(record)
	}
}
