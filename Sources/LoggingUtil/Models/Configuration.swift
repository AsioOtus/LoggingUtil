public struct Configuration: Codable {
	public let keyValue: [String: String]
	
	public init (_ keyValue: [String: String]) {
		self.keyValue = keyValue
	}
	
	public func combine (with another: Self?) -> Self {
		Self(keyValue.merging(another?.keyValue ?? [:]) { valueA, _ in valueA })
	}
}
