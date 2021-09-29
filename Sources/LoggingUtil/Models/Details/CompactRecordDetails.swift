public extension CompactRecordDetails {
	enum Enabling: RecordDetailsEnabling {
		case disabled
		case enabled(source: Bool = true, tags: Bool = true)
		
		public static let defaultEnabling = enabled()
		public static let fullEnabled = enabled()
	}
}

public struct CompactRecordDetails: RecordDetails {
	public let source: [String]?
	public let tags: Set<String>?
	
	public func combined (with another: Self?) -> Self {
		Self(
			source: (another?.source ?? []) + (source ?? []),
			tags: (another?.tags ?? []).union(tags ?? [])
		)
	}
	
	public func moderated (_ enabling: Enabling) -> Self? {
		guard case let .enabled(source, tags) = enabling else { return nil }
		
		return .init(
			source: source ? self.source : nil,
			tags: tags ? self.tags : nil
		)
	}
}
