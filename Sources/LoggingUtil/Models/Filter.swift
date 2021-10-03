public typealias Filter<Message: Codable, Details: RecordDetails> = (Record<Message, Details>) -> Bool

public enum Filters {
	public static func whitelist <Message: Codable, Details: RecordDetails> (_ allowedValues: Set<String>) -> Filter<Message, Details> {
		{ record in
			guard let filterValue = record.configuration?.keyValue["filter"], allowedValues.contains(filterValue) else { return false }
			return true
		}
	}
	
	public static func blacklist <Message: Codable, Details: RecordDetails> (_ deniedValues: Set<String>) -> Filter<Message, Details> {
		{ record in
			guard let filterValue = record.configuration?.keyValue["filter"], deniedValues.contains(filterValue) else { return true }
			return false
		}
	}
}
