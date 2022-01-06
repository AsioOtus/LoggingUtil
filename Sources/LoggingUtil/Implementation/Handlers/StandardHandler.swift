public class StandardHandler <Message: Codable, Details: RecordDetails> {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handlers: [AnyHandler<Message, Details>],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handlers = handlers
	}
	
	public convenience init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		@ArrayBuilder _ handlers: () -> [AnyHandler<Message, Details>]
	) {
		self.init(handlers(), label: label, file: file, line: line)
	}
	
	public convenience init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init([], label: label, file: file, line: line)
	}
	
	public convenience init <H: Handler> (
		_ handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	where H.Message == Message, H.Details == Details
	{
		self.init([handler.eraseToAnyHandler()], label: label, file: file, line: line)
	}
	
	public convenience init (
		_ handler: AnyHandler<Message, Details>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init([handler], label: label, file: file, line: line)
	}
}

extension StandardHandler: CustomizableHandler {
	public func handle (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		handlers.forEach{ $0.handle(record: record) }
	}
}

public extension StandardHandler {
	@discardableResult
	func handler <H: Handler> (_ handler: H) -> Self where H.Message == Message, H.Details == Details {
		self.handlers.append(handler.eraseToAnyHandler())
		return self
	}
	
	@discardableResult
	func handler (_ handler: AnyHandler<Message, Details>) -> Self {
		self.handlers.append(handler)
		return self
	}
	
	@discardableResult
	func handlers (@ArrayBuilder _ handlers: () -> [AnyHandler<Message, Details>]) -> Self {
		self.handlers.append(contentsOf: handlers())
		return self
	}
}

public extension AnyHandler {
	static func standard (
		_ handlers: [AnyHandler<Message, Details>] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self {
		StandardHandler(
			handlers,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func standard <H: Handler> (
		_ handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self where H.Message == Message, H.Details == Details {
		StandardHandler(
			handler,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func standard (
		_ handler: AnyHandler<Message, Details>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self	{
		StandardHandler(
			handler,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
}
