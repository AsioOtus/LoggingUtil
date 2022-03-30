public typealias CompactDetails = CompactRecordDetails

public extension CompactRecordDetails {
    enum Enabling: RecordDetailsEnabling {
		case disabled
		case enabled(prefix: Bool = true, source: Bool = true, tags: Bool = true)
		
		public static let defaultEnabling = enabled()
		public static let fullEnabled = enabled()
        public static let fullDisabled = disabled
	}
}

public struct CompactRecordDetails: RecordDetails {
	public let prefix: String?
	public let source: [String]?
	public let tags: Set<String>?
	
	public init (prefix: String? = nil, source: [String]? = nil, tags: Set<String>? = nil) {
		self.prefix = prefix
        self.source = source
        self.tags = tags
    }
	
	public init (prefix: String? = nil, source: String? = nil, tag: String? = nil) {
		self.prefix = prefix
		self.source = source.map{ [$0] } ?? []
		self.tags =  tag.map{ [$0] } ?? []
	}
    
	public func combined (with another: Self) -> Self {
		Self(
			prefix: prefix ?? another.prefix,
			source: combine(source, another.source) { $1 + $0 },
			tags: combine(tags, another.tags) { $0.union($1) }
		)
	}
	
	public func moderated (_ enabling: Enabling) -> Self? {
		guard case let .enabled(prefix, source, tags) = enabling else { return nil }
		
		return .init(
			prefix: prefix ? self.prefix : nil,
			source: source ? self.source : nil,
			tags:   tags ? self.tags : nil
		)
	}
}
