public struct CustomConverter <InputMessage: Codable, InputDetails: RecordDetails, OutputMessage>: PlainConverter {
	let conversion: (Record<InputMessage, InputDetails>) -> OutputMessage
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		_ conversion: @escaping (Record<InputMessage, InputDetails>) -> OutputMessage
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.conversion = conversion
	}
	
	public func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage { conversion(record) }
}
