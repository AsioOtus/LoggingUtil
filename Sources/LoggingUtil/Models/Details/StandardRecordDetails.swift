public typealias StandardDetails = StandardRecordDetails

public extension StandardRecordDetails {
    enum Enabling: RecordDetailsEnabling {
		case disabled
		case enabled(
			prefix: Bool = true,
			source: Bool = true,
			tags: Bool = true,
			keyValue: Bool = false,
			comment: Bool = false
		 )
		
		public static let defaultEnabling = enabled()
		
		public static let fullEnabled = enabled(
			prefix: true,
			source: true,
			tags: true,
			keyValue: true,
			comment: true
		)
        
        public static let fullDisabled = disabled
	}
}

public struct StandardRecordDetails: RecordDetails {
	public let prefix: String?
	public let source: [String]?
	public let tags: Set<String>?
	public let keyValue: [String: String]?
	public let comment: String?
	
	public init (
		prefix: String? = nil,
		source: [String]? = nil,
		tags: Set<String>? = nil,
		keyValue: [String: String]? = nil,
		comment: String? = nil
	) {
		self.prefix = prefix
		self.source = source
		self.tags = tags
		self.keyValue = keyValue
		self.comment = comment
	}
	
	public func combined (with another: Self) -> Self {		
		Self(
			prefix: prefix ?? another.prefix,
			source: combine(source, another.source) { $1 + $0 },
			tags: combine(tags, another.tags) { $0.union($1) },
			keyValue: combine(keyValue, another.keyValue) { $0.merging($1) { value, _ in value } },
			comment: comment ?? another.comment
		)
	}
	
	public func moderated (_ enabling: Enabling) -> Self? {
		guard case let .enabled(prefix, source, tags, keyValue, comment) = enabling else { return nil }
		
		return .init(
			prefix:   prefix ? self.prefix : nil,
			source:   source   ? self.source : nil,
			tags:     tags     ? self.tags : nil,
			keyValue: keyValue ? self.keyValue : nil,
			comment:  comment  ? self.comment : nil
		)
	}
}
