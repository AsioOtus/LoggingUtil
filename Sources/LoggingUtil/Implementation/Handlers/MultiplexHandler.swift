public class MultiplexHandler <Message: Codable, Details: RecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var condition: (Record<Message, Details>) -> Bool
	
	public var handlers: [AnyHandler<Message, Details>]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handlers: [AnyHandler<Message, Details>] = [],
		condition: @escaping (Record<Message, Details>) -> Bool = { _ in true },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handlers = handlers
		self.condition = condition
	}
	
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, condition(record) else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = (record.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let record = record.replace(metaInfo, details)
		
		handlers.forEach{ $0.log(record: record) }
	}
}

public extension MultiplexHandler {
	@discardableResult
	func handler <H: Handler> (_ handler: H) -> Self where H.Message == Message, H.Details == Details {
		self.handlers.append(handler.eraseToAnyHandler())
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
