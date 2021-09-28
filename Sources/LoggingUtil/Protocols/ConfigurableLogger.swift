public protocol ConfigurableLogger: Logger {
	var isEnabled: Bool { get set }
	var level: Level { get set }
	var details: Details? { get set }
}

extension ConfigurableLogger {
	@discardableResult
	public func isEnabled (_ isEnabled: Bool) -> Self {
		var selfCopy = self
		selfCopy.isEnabled = isEnabled
		return selfCopy
	}
	
	@discardableResult
	public func level (_ level: Level) -> Self {
		var selfCopy = self
		selfCopy.level = level
		return selfCopy
	}
	
	@discardableResult
	public func details (_ details: Details) -> Self {
		var selfCopy = self
		selfCopy.details = details
		return selfCopy
	}
}
