#if canImport(Combine)

import Combine
import Foundation

@available(iOS 13, macOS 15.0, *)
public class ReactiveLogHandler<Message: Codable, Details: LogRecordDetails> {	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .defaultEnabling
	public let identifier: String
	public let label: String
	
	public let stream = PassthroughSubject<LogRecord<Message, Details>, Never>()
	
	public init (
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		let identifier = UUID().uuidString
		self.identifier = identifier
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line, identifier)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveLogHandler: ConfigurableLogHandler {
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)??.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		stream.send(logRecord)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveLogHandler {	
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
