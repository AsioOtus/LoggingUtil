import Foundation

public extension MetaInfo {
	enum Enabling {
		case disable
		case enabled(
			timestamp: Bool = false,
			level: Bool = true,
			label: Bool = false,
			codeInfo: Bool = false,
			stack: Bool = false
		)
	}
}

public struct MetaInfo: Codable {
	public let timestamp: Double
	public let level: Level
	public let label: String?
	public let file: String
	public let line: Int
}

public extension MetaInfo {
    static func now (level: Level, label: String?, file: String, line: Int) -> Self {
        .init(timestamp: Date().timeIntervalSince1970, level: level, label: label, file: file, line: line)
    }
}

internal extension MetaInfo {
    static var empty: Self { .init(timestamp: 0, level: .trace, label: nil, file: "", line: 0) }
}
