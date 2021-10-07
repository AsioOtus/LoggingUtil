import Combine

@available(iOS 13, macOS 15.0, *)
public class ReactiveHandler <Message: Codable, Details: RecordDetails> {	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var configuration: Configuration?
	public var filters = [Filter<Message, Details>]()
	
	public let stream = PassthroughSubject<Record<Message, Details>, Never>()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler: CustomizableHandler {
	public func handle (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		stream.send(record)
	}
}

@available(iOS 13, macOS 15.0, *)
extension ReactiveHandler {	
	@discardableResult
	public func subscribe (_ subscription: (PassthroughSubject<Record<Message, Details>, Never>) -> ()) -> Self {
		subscription(stream)
		return self
	}
}
