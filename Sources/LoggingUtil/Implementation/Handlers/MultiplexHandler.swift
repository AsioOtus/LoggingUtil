public class MultiplexHandler <Message: Codable, Details: RecordDetails>: CustomizableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var configuration: Configuration?
	public var filters = [Filter<Message, Details>]()
	
	public var handlers: [AnyHandler<Message, Details>]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handlers: [AnyHandler<Message, Details>] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handlers = handlers
	}
	
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		handlers.forEach{ $0.log(record: record) }
	}
}

public extension MultiplexHandler {
	@discardableResult
	func handler <H: Handler> (_ handler: H) -> Self where H.Message == Message, H.Details == Details {
		self.handlers.append(handler.eraseToAnyHandler())
		return self
	}
}
