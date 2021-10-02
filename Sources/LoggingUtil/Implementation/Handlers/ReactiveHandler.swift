#if canImport(Combine)

import Combine

@available(iOS 13, macOS 15.0, *)
public class ReactiveHandler <Message: Codable, Details: RecordDetails> {	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var filter: Filter<Message, Details>
	
	public let stream = PassthroughSubject<Record<Message, Details>, Never>()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		filter: @escaping Filter<Message, Details> = { _ in true },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.filter = filter
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler: ConfigurableHandler {
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filter(record) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
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
