public protocol ConfigurableExporter: Exporter, AnyObject {
	var isEnabled: Bool { get set }
	var level: Level { get set }
}

public extension ConfigurableExporter {
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
}
