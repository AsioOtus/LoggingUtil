public protocol DetailsEnablingCustomization {
	associatedtype Details: RecordDetails
	
	var detailsEnabling: Details.Enabling { get set }
}

public extension DetailsEnablingCustomization {
	@discardableResult
	func detailsEnabling (_ detailsEnabling: Details.Enabling) -> Self {
		var selfCopy = self
		selfCopy.detailsEnabling = detailsEnabling
		return selfCopy
	}
}
