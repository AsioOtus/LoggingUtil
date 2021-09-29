public extension MetaInfo {
	enum Enabling {
		case disable
		case enabled(
			timestamp: Bool = false,
			level: Bool = true,
			file: Bool = false,
			function: Bool = false,
			line: Bool = false,
			stack: Bool = false
		)
	}
}

public struct MetaInfo: Codable {
	public let timestamp: Double
	public let level: Level
	public let file: String
	public let line: Int
	public let stack: [IdentificationInfo]
	
	public func add (_ identificationInfo: IdentificationInfo) -> Self {
		.init(timestamp: timestamp, level: level, file: file, line: line, stack: stack + [identificationInfo])
	}
}
