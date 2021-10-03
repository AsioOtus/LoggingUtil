public protocol IsEnabledCustomizable {
	var isEnabled: Bool { get set }
}

public extension IsEnabledCustomizable {
	@discardableResult
	func isEnabled (_ isEnabled: Bool) -> Self {
		var selfCopy = self
		selfCopy.isEnabled = isEnabled
		return selfCopy
	}
}
