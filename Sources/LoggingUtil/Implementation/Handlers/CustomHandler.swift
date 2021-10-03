public class CustomHandler <Message: Codable, Details: RecordDetails>: CustomizableHandler {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var configuration: Configuration?
	public var filters = [Filter<Message, Details>]()
	
	public var handling: (Record<Message, Details>) -> ()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		_ handling: @escaping (Record<Message, Details>) -> () = { _ in }
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handling = handling
	}

	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		handling(record)
	}
}

public extension CustomHandler {
	@discardableResult
	func handling (_ handling: @escaping (Record<Message, Details>) -> ()) -> Self {
		self.handling = handling
		return self
	}
}
