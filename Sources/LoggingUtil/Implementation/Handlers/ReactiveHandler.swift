#if canImport(Combine)

import Combine

@available(iOS 13, macOS 15.0, *)
public class ReactiveHandler <Message: Codable, Details: LogRecordDetails> {	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public let stream = PassthroughSubject<LogRecord<Message, Details>, Never>()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler: ConfigurableHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(identificationInfo)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)??.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		stream.send(logRecord)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler {	
	@discardableResult
	public func subscribe (_ subscription: (PassthroughSubject<LogRecord<Message, Details>, Never>) -> ()) -> Self {
		subscription(stream)
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}

#endif
