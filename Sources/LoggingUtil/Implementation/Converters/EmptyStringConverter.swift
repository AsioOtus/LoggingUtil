public struct EmptyStringConverter: PlainConverter {
	public typealias InputMessage = String
	public typealias InputDetails = StandardRecordDetails
	public typealias OutputMessage = String
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
	
	public func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage { "" }
}
