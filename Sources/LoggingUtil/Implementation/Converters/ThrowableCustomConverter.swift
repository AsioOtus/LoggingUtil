public struct ThrowableCustomConverter <InputMessage: Codable, InputDetails: RecordDetails, OutputMessage>: ThrowableConverter {
	let conversion: (Record<InputMessage, InputDetails>) throws -> OutputMessage
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		alias: String? = nil,
		file: String = #file,
		line: Int = #line,
		_ conversion: @escaping (Record<InputMessage, InputDetails>) throws -> OutputMessage
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.conversion = conversion
	}
	
	public func convert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage { try conversion(record)	}
}
