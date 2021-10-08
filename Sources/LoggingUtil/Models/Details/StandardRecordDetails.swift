public extension StandardRecordDetails {
	enum Enabling: RecordDetailsEnabling {
		case disable
		case enabled(
			source: Bool = true,
			tags: Bool = true,
			keyValue: Bool = false,
			comment: Bool = false
		 )
		
		public static let defaultEnabling = enabled()
		
		public static let fullEnabled = enabled(
			source: true,
			tags: true,
			keyValue: true,
			comment: true
		)
	}
}

public struct StandardRecordDetails: RecordDetails {
	public let source: [String]?
	public let tags: Set<String>?
	public let keyValue: [String: String]?
	public let comment: String?
	
	public init (
		source: [String]? = nil,
		tags: Set<String>? = nil,
		keyValue: [String: String]? = nil,
		comment: String? = nil
	) {
		self.source = source
		self.tags = tags
		self.keyValue = keyValue
		self.comment = comment
	}
	
	public func combined (with another: Self) -> Self {		
		Self(
			source: combine(source, another.source) { $1 + $0 },
			tags: combine(tags, another.tags) { $0.union($1) },
			keyValue: combine(keyValue, another.keyValue) { $0.merging($1) { value, _ in value } },
			comment: comment ?? another.comment
		)
	}
	
	public func moderated (_ enabling: Enabling) -> Self? {
		guard case let .enabled(source, tags, keyValue, comment) = enabling else { return nil }
		
		return .init(
			source:   source   ? self.source : nil,
			tags:     tags     ? self.tags : nil,
			keyValue: keyValue ? self.keyValue : nil,
			comment:  comment  ? self.comment : nil
		)
	}
}
