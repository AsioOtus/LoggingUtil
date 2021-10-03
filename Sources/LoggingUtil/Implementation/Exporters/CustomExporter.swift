public class CustomExporter <Message: Codable>: CustomizableExporter {
	public var isEnabled = true
	public var level: Level = .trace
	
	let exporting: (MetaInfo, Message) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		_ exporting: @escaping (MetaInfo, Message) -> Void
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.exporting = exporting
	}
	
	public func export (metaInfo: MetaInfo, message: Message) {
		guard isEnabled, metaInfo.level >= level else { return }
		exporting(metaInfo, message)
	}
}
