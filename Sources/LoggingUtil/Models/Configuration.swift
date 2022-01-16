public struct Configuration {
	public let keyValue: [Key: Any]
	
	public init (_ keyValue: [Key: Any]) {
		self.keyValue = keyValue
	}
	
	public func combined (with another: Self) -> Self {
		Self(keyValue.merging(another.keyValue) { value, _ in value })
	}
}

public extension Configuration {
	struct Key: Hashable, Codable, ExpressibleByStringLiteral {
		let key: String
		
		public init (stringLiteral key: String) {
			self.key = key
		}
	}
}
