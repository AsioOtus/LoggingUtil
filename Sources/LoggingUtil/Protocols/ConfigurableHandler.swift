public protocol ConfigurableHandler: Handler, AnyObject {
	var isEnabled: Bool { get set }
	var level: Level { get set }
	var details: Details? { get set }
}

public extension ConfigurableHandler {
	@discardableResult
	func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
	
	@discardableResult
	func level (_ level: Level) -> Self {
		self.level = level
		return self
	}
	
	@discardableResult
	func details (_ details: Details) -> Self {
		self.details = details
		return self
	}
}
