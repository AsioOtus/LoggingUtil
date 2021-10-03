public class IntermediateHandler <H: Handler>: CustomizableHandler {
	public typealias Message = H.Message
	public typealias Details = H.Details
	
	public var isEnabled = true
	public var level: Level = .trace
	public var details: Details? = nil
	public var detailsEnabling: Details.Enabling = .fullEnabled
	public var configuration: Configuration?
	public var filters = [Filter<Message, Details>]()
	
	public var handler: H
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		_ handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.handler = handler
	}
	
	public func log (record: Record<Message, Details>) {
		guard isEnabled, record.metaInfo.level >= level, filters.allSatisfy({ $0(record) }) else { return }
		
		let record = record
			.add(identificationInfo)
			.add(details)
			.moderateDetails(detailsEnabling)
			.add(configuration)
		
		handler.log(record: record)
	}
}
