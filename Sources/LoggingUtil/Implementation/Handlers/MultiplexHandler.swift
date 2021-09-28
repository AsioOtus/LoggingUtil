class MultiplexHandler: ConfigurableHandler {
	public typealias Message = String
	public typealias Details = StandardRecordDetails
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var handlers: [AnyHandler<Message, Details>]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		handlers: [AnyHandler<Message, Details>] = [],
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.handlers = handlers
	}
	
	func log (record: Record<String, StandardRecordDetails>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = (record.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let record = record.replace(metaInfo, details)
		
		handlers.forEach{ $0.log(record: record) }
	}
}

extension MultiplexHandler {	
	@discardableResult
	func handler <H: Handler> (_ handler: H) -> Self where H.Message == Message, H.Details == Details {
		self.handlers.append(handler.eraseToAnyHandler())
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		self.detailsEnabling = detailsEnabling
		return self
	}
}
