public enum Level: String, Codable, CaseIterable {
	case trace
	case debug
	case info
	case notice
	case warning
	case error
	case critical
	case fault
	
	public var order: Int {
		let order: Int
		
		switch self {
		case .trace:
			order = 0
		case .debug:
			order = 1
		case .info:
			order = 2
		case .notice:
			order = 3
		case .warning:
			order = 4
		case .error:
			order = 5
		case .critical:
			order = 6
		case .fault:
			order = 7
		}
		
		return order
	}
	
	public static func >= (lhs: Self, rhs: Self) -> Bool { lhs.order >= rhs.order }
	public static func <= (lhs: Self, rhs: Self) -> Bool { lhs.order <= rhs.order }
}
