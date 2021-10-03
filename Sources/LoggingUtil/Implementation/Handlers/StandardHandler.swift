public class StandardHandler <C: Connector>: ConfigurableHandler {
	public typealias Message = C.Message
	public typealias Details = C.Details
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var filter: Filter<Message, Details>
	
	public var connector: C
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ connector: C,
		filter: @escaping Filter<Message, Details> = { _ in true },
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.connector = connector
		self.filter = filter
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filter(record) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		connector.log(record)
	}
}

public extension StandardHandler {
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
