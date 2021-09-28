public class MultipleClosuresHandler <Message: Codable, Details: RecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var handlings: [(Record<Message, Details>) -> ()]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handlings: [(Record<Message, Details>) -> ()] = [],
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.handlings = handlings
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = record.details?.combined(with: self.details) ?? self.details?.moderated(detailsEnabling)
		let record = record.replace(metaInfo, details)
		
		handlings.forEach{ $0(record) }
	}
}

extension MultipleClosuresHandler {
	@discardableResult
	func handling (_ handling: @escaping (Record<Message, Details>) -> ()) -> Self {
		self.handlings.append(handling)
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
