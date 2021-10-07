public struct Configuration: Codable {
	public let keyValue: [Key: String]
	
	public init (_ keyValue: [Key: String]) {
		self.keyValue = keyValue
	}
	
	public func combine (with another: Self?) -> Self {
		Self(keyValue.merging(another?.keyValue ?? [:]) { valueA, _ in valueA })
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
