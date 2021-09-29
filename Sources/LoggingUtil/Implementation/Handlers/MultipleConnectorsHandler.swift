public class MultipleConnectorsHandler <Message: Codable, Details: RecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var configuration: Configuration?
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var condition: (Record<Message, Details>) -> Bool
	
	public var connectors: [AnyConnector<Message, Details>]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ connectors: [AnyConnector<Message, Details>] = [],
		condition: @escaping (Record<Message, Details>) -> Bool = { _ in true },
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.connectors = connectors
		self.condition = condition
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, condition(record) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		connectors.forEach{ $0.log(record) }
	}
}

public extension MultipleConnectorsHandler {	
	@discardableResult
	func connector <C: Connector> (_ connector: C) -> Self where C.Message == Message, C.Details == Details {
		self.connectors.append(connector.eraseToAnyConnector())
		return self
	}
	
	@discardableResult
	func connector (_ connector: AnyConnector<Message, Details>) -> Self {
		self.connectors.append(connector)
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
