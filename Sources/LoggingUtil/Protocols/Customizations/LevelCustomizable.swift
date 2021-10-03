public protocol LevelCustomizable {
	var level: Level { get set }
}

public extension LevelCustomizable {
	@discardableResult
	func level (_ level: Level) -> Self {
		var selfCopy = self
		selfCopy.level = level
		return selfCopy
	}
}
