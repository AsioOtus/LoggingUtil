public class MultiplexCustomHandler <Message: Codable, Details: RecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var filter: Filter<Message, Details>
	
	public var handlings: [(Record<Message, Details>) -> ()]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handlings: [(Record<Message, Details>) -> ()] = [],
		filter: @escaping Filter<Message, Details> = { _ in true },
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handlings = handlings
		self.filter = filter
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filter(record) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
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
	func filter (_ filter: @escaping Filter<Message, Details>) -> Self {
		self.filter = filter
		return self
	}
}
