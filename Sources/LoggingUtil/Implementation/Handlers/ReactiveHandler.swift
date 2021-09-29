#if canImport(Combine)

import Combine

@available(iOS 13, macOS 15.0, *)
public class ReactiveHandler <Message: Codable, Details: RecordDetails> {	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public let stream = PassthroughSubject<Record<Message, Details>, Never>()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler: ConfigurableHandler {
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = (record.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let record = record.replace(metaInfo, details)
		
		stream.send(record)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler {	
	@discardableResult
	public func subscribe (_ subscription: (PassthroughSubject<Record<Message, Details>, Never>) -> ()) -> Self {
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
