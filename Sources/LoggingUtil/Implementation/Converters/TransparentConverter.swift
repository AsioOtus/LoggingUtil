public struct TransparentConverter <Message: Codable, Details: RecordDetails>: PlainConverter {
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
	
	public func convert (_ record: Record<Message, Details>) -> Record<Message, Details> { record }
}
