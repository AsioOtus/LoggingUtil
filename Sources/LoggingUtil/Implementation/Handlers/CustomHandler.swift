public class CustomHandler <Message: Codable, Details: RecordDetails> {
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var configuration: Configuration?
	public var filters = [Filter<Message, Details>]()
	
	public var handlings: [(Record<Message, Details>) -> ()]
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handlings: [(Record<Message, Details>) -> ()] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handlings = handlings
	}
	
	public convenience init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		_ handling: @escaping (Record<Message, Details>) -> ()
	) {
		self.init([handling], label: label, file: file, line: line)
	}
}

extension CustomHandler: CustomizableHandler {
	public func handle (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		handlings.forEach{ $0(record) }
	}
}

public extension CustomHandler {
	@discardableResult
	func handling (_ handling: @escaping (Record<Message, Details>) -> ()) -> Self {
		self.handlings.append(handling)
		return self
	}
}
