public class MultiplexCustomHandler <Message: Codable, Details: RecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var condition: (Record<Message, Details>) -> Bool
	
	public var handlings: [(Record<Message, Details>) -> ()]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handlings: [(Record<Message, Details>) -> ()] = [],
		condition: @escaping (Record<Message, Details>) -> Bool = { _ in true },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handlings = handlings
		self.condition = condition
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, condition(record) else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = (record.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let record = record.replace(metaInfo, details)
		
		handlings.forEach{ $0(record) }
	}
}

public extension MultiplexCustomHandler {
	@discardableResult
	func handling (_ handling: @escaping (Record<Message, Details>) -> ()) -> Self {
		self.handlings.append(handling)
		return self
	}
	
	@discardableResult
	func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
	
	@discardableResult
	func condition (_ condition: @escaping (Record<Message, Details>) -> Bool) -> Self {
		self.condition = condition
		return self
	}
}
