public protocol FiltersCustomizable {
	associatedtype Message: Codable
	associatedtype Details: RecordDetails
	
	var filters: [Filter<Message, Details>] { get set }
}

public extension FiltersCustomizable {
	@discardableResult
	func filter (_ filter: @escaping Filter<Message, Details>) -> Self {
		var selfCopy = self
		selfCopy.filters.append(filter)
		return selfCopy
	}
}
