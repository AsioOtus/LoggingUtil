public class IntermediateHandler <H: Handler>: ConfigurableHandler {
	public typealias Message = H.Message
	public typealias Details = H.Details
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var filter: Filter<Message, Details>
	
	public var handler: H
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handler: H,
		filter: @escaping Filter<Message, Details> = { _ in true },
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handler = handler
		self.filter = filter
	}
	
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filter(record) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		handler.log(record: record)
	}
}

public extension IntermediateHandler {
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
