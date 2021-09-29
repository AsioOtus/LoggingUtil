public class MultipleConnectorsHandler <Message: Codable, Details: RecordDetails>: ConfigurableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	
	public var connectors: [AnyConnector<Message, Details>]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ connectors: [AnyConnector<Message, Details>] = [],
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.connectors = connectors
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level else { return }
		
		let metaInfo = record.metaInfo.add(identificationInfo)
		let details = (record.details?.combined(with: self.details) ?? self.details)?.moderated(detailsEnabling)
		let record = record.replace(metaInfo, details)
		
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
}
