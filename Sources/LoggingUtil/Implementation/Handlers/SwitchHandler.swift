public class SwitchHandler <Message: Codable, Details: RecordDetails>: CustomizableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var configuration: Configuration?
	public var filters = [Filter<Message, Details>]()
	
	public var handlers = [String: AnyHandler<Message, Details>]()
	public var defaultHandler: AnyHandler<Message, Details>? = nil
	
	public var defaultForUnknownValue: Bool = true
	
	public var identificationInfo: IdentificationInfo
	
	public init (
		_ handlers: [String: AnyHandler<Message, Details>],
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
		line: Int = #line
	) {
		self.init([:], label: label, file: file, line: line)
	}
	
	public convenience init <H: Handler> (
		_ key: String,
		_ handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	where H.Message == Message, H.Details == Details
	{
		self.init([key: handler.eraseToAnyHandler()], label: label, file: file, line: line)
	}
	
	public convenience init (
		_ key: String,
		_ handler: AnyHandler<Message, Details>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init([key: handler], label: label, file: file, line: line)
	}
	
	public func handle (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		if let switchValue = record.configuration?.keyValue["switch"] {
			if let handler = handlers[switchValue] {
				handler.handle(record: record)
			} else if defaultForUnknownValue {
				defaultHandler?.handle(record: record)
			}
		} else {
			defaultHandler?.handle(record: record)
		}
	}
}

public extension SwitchHandler {
	@discardableResult
	func handler <H: Handler> (_ key: String, _ handler: H) -> Self where H.Message == Message, H.Details == Details {
		self.handlers[key] = handler.eraseToAnyHandler()
		return self
	}
	
	@discardableResult
	func handler (_ key: String, _ handler: AnyHandler<Message, Details>) -> Self {
		self.handlers[key] = handler
		return self
	}
	
	@discardableResult
	func defaultHandler <H: Handler> (_ key: String, _ handler: H) -> Self where H.Message == Message, H.Details == Details {
		self.defaultHandler = handler.eraseToAnyHandler()
		return self
	}
	
	@discardableResult
	func defaultHandler (_ key: String, _ handler: AnyHandler<Message, Details>) -> Self {
		self.defaultHandler = handler
		return self
	}
	
	@discardableResult
	func defaultForUnknownValue (_ flag: Bool) -> Self {
		self.defaultForUnknownValue = flag
		return self
	}
}
