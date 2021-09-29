public protocol ConfigurableLogger: Logger {
	var isEnabled: Bool { get set }
	var level: Level { get set }
	var details: Details? { get set }
}

public extension ConfigurableLogger {
	@discardableResult
	func isEnabled (_ isEnabled: Bool) -> Self {
		var selfCopy = self
		selfCopy.isEnabled = isEnabled
		return selfCopy
	}
	
	@discardableResult
	func level (_ level: Level) -> Self {
		var selfCopy = self
		selfCopy.level = level
		return selfCopy
	}
	
	@discardableResult
	func details (_ details: Details) -> Self {
		var selfCopy = self
		selfCopy.details = details
		return selfCopy
	}
}
