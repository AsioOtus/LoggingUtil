public extension CompactRecordDetails {
    enum Enabling: RecordDetailsEnabling {
		case disabled
		case enabled(source: Bool = true, tags: Bool = true)
		
		public static let defaultEnabling = enabled()
		public static let fullEnabled = enabled()
        public static let fullDisabled = disabled
	}
}

public struct CompactRecordDetails: RecordDetails {
	public let source: [String]?
	public let tags: Set<String>?
	
    public init (source: [String]? = nil, tags: Set<String>? = nil) {
        self.source = source
        self.tags = tags
    }
    
	public func combined (with another: Self) -> Self {
		Self(
			source: combine(source, another.source) { $1 + $0 },
			tags: combine(tags, another.tags) { $0.union($1) }
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
