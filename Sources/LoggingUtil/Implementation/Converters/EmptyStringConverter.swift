public struct EmptyStringConverter: PlainConverter {
	public let identificationInfo: IdentificationInfo
	
	public init (
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
	}
	
	public func convert (_ record: Record<String, StandardRecordDetails>) -> String { "" }
}
