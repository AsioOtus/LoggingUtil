public struct MessageOnlyConverter <Message: Codable, Details: RecordDetails>: PlainConverter {
	public typealias InputMessage = Message
	public typealias InputDetails = Details
	public typealias OutputMessage = Message
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
	
	public func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage { record.message }
}
