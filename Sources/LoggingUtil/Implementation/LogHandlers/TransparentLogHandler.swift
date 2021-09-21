import Foundation

public class TransparentLogHandler<Handler: LogHandler>: ConfigurableLogHandler {
	public typealias Message = Handler.Message
	public typealias Details = Handler.Details
	
	public var isEnabled = true
	public var level = LogLevel.trace
	public var details: Details? = nil
	public var handler: Handler
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public let label: String
	public let identifier: String
	
	public init (
		handler: Handler,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		let identifier = UUID().uuidString
		self.identifier = identifier
		self.label = label ?? LabelBuilder.build(String(describing: Self.self), #file, #line, identifier)
		
		self.handler = handler
	}
	
	public func log (logRecord: LogRecord<Message, Details>) {
		guard isEnabled, logRecord.metaInfo.level >= level else { return }
		
		let metaInfo = logRecord.metaInfo.add(label: label)
		let details = (logRecord.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let logRecord = logRecord.replace(metaInfo, details)
		
		handler.log(logRecord: logRecord)
	}
}

extension TransparentLogHandler {
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
