public protocol DetailsCustomizable {
	associatedtype Details: RecordDetails
	
	var details: Details? { get set }
}

public extension DetailsCustomizable {
	@discardableResult
	func details (_ details: Details) -> Self {
		var selfCopy = self
		selfCopy.details = details
		return selfCopy
	}
}
