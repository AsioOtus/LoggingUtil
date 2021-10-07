public typealias Filter<Message: Codable, Details: RecordDetails> = (Record<Message, Details>) -> Bool

public enum Filters {
	public static func whitelist <Message: Codable, Details: RecordDetails> (_ allowedValues: Set<String>) -> Filter<Message, Details> {
		{ record in
			guard let filterValue = record.configuration?.keyValue[.filterKey], allowedValues.contains(filterValue) else { return false }
			return true
		}
	}
	
	public static func blacklist <Message: Codable, Details: RecordDetails> (_ deniedValues: Set<String>) -> Filter<Message, Details> {
		{ record in
			guard let filterValue = record.configuration?.keyValue[.filterKey], deniedValues.contains(filterValue) else { return true }
			return false
		}
	}
	
	public static func minLevel <Message: Codable, Details: RecordDetails> (_ level: Level) -> Filter<Message, Details> {
		{ record in record.metaInfo.level >= level }
	}
	
	public static func maxLevel <Message: Codable, Details: RecordDetails> (_ level: Level) -> Filter<Message, Details> {
		{ record in record.metaInfo.level <= level }
	}
}

public extension Filters {
	static func sourceContains <Message: Codable> (oneOf values: Set<String>) -> Filter<Message, StandardRecordDetails> {
		{ record in
			guard let source = record.details?.source else { return false }
			return !Set(source).intersection(values).isEmpty
		}
	}
	
	static func tagsContains <Message: Codable> (oneOf values: Set<String>) -> Filter<Message, StandardRecordDetails> {
		{ record in
			guard let tags = record.details?.tags else { return false }
			return !tags.intersection(values).isEmpty
		}
	}
}

public extension Filters {
	static func invert <Message: Codable, Details: RecordDetails> (_ filter: @escaping Filter<Message, Details>) -> Filter<Message, Details> {
		{ record in	!filter(record)	}
	}
}

public prefix func ! <Message: Codable, Details: RecordDetails> (_ filter: @escaping Filter<Message, Details>) -> Filter<Message, Details> {
	Filters.invert(filter)
}

public extension Configuration.Key {
	static var filter: Self { "filter" }
}
