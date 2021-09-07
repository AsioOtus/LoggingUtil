public class PrintExporter: LogExporter {
	public var isEnabled = true
	
	public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
		guard isEnabled else { return }
		print(message)
	}
}

extension PrintExporter {
	@discardableResult
	public func isEnabled (_ isEnabled: Bool) -> Self {
		self.isEnabled = isEnabled
		return self
	}
}
