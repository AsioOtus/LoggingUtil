public extension MetaInfo {
	enum Enabling {
		case disable
		case enabled(
			timestamp: Bool = false,
			level: Bool = true,
			labels: Bool = false
		)
	}
}

public struct MetaInfo: Codable {
	public let timestamp: Double
	public let level: LogLevel
	public let stack: [IdentificationInfo]
	
	public func add (_ identificationInfo: IdentificationInfo) -> Self {
		.init(timestamp: timestamp, level: level, stack: stack + [identificationInfo])
	}
}
