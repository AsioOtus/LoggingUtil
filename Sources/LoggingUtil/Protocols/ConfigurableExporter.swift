public protocol ConfigurableExporter: Exporter, AnyObject {
	var isEnabled: Bool { get set }
	var level: Level { get set }
}

extension ConfigurableExporter {
	@discardableResult
	public func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
	
	@discardableResult
	public func level (_ level: Level) -> Self {
		self.level = level
		return self
	}
}
