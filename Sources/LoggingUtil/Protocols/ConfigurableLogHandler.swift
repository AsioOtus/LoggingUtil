public protocol ConfigurableLogHandler: LogHandler, AnyObject {
	var isEnabled: Bool { get set }
	var level: LogLevel { get set }
	var details: Details? { get set }
}

extension ConfigurableLogHandler {
	@discardableResult
	public func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
	
	@discardableResult
	public func level (_ level: LogLevel) -> Self {
		self.level = level
		return self
	}
	
	@discardableResult
	public func details (_ details: Details) -> Self {
		self.details = details
		return self
	}
}
