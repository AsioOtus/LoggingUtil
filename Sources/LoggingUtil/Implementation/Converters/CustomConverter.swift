public struct CustomConverter <InputMessage: Codable, InputDetails: RecordDetails, OutputMessage>: PlainConverter {
	let conversion: (Record<InputMessage, InputDetails>) -> OutputMessage
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		alias: String? = nil,
		file: String = #file,
		line: Int = #line,
		_ conversion: @escaping (Record<InputMessage, InputDetails>) -> OutputMessage
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.conversion = conversion
	}
	
	public func convert (_ record: Record<InputMessage, InputDetails>) -> OutputMessage { conversion(record) }
}
