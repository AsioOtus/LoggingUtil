public protocol ConfigurableLogExporter: LogExporter, AnyObject {
	var isEnabled: Bool { get set }
	var level: LogLevel { get set }
}

extension ConfigurableLogExporter {
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
}
