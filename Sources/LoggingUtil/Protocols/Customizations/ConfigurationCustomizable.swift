public protocol ConfigurationCustomizable {
	var configuration: Configuration? { get set }
}

public extension ConfigurationCustomizable {
	@discardableResult
	func configuration (_ configuration: Configuration) -> Self {
		var selfCopy = self
		selfCopy.configuration = configuration
		return selfCopy
	}
}
