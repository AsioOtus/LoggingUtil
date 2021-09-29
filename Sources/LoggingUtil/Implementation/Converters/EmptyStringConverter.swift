public struct EmptyStringConverter: PlainConverter {
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
	
	public func convert (_ record: Record<String, StandardRecordDetails>) -> String { "" }
}
