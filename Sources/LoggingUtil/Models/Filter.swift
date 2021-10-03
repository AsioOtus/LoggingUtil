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
	
	public static func sourceContains <Message: Codable> (oneOf values: Set<String>) -> Filter<Message, StandardRecordDetails> {
		{ record in
			guard let source = record.details?.source else { return false }
			let sourceSet = Set(source)
			let valuesSet = Set(values)
			
			return !sourceSet.intersection(values).isEmpty
		}
	}
}
