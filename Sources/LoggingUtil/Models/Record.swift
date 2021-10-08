public struct Record <Message: Codable, Details: RecordDetails>: Codable {
	public let metaInfo: MetaInfo
	public let message: Message
	public let details: Details?
	public let configuration: Configuration?
	
	public func add (_ identificationInfo: IdentificationInfo) -> Self {
		.init(metaInfo: metaInfo.add(identificationInfo), message: message, details: details, configuration: configuration)
	}
	
	public func add (_ identificationInfo: [IdentificationInfo]) -> Self {
		.init(metaInfo: metaInfo.add(identificationInfo), message: message, details: details, configuration: configuration)
	}
	
	public func add (_ details: Details?) -> Self {
		.init(metaInfo: metaInfo, message: message, details: combine(self.details, details) { $0.combined(with: $1) }, configuration: configuration)
	}

	public func moderateDetails (_ detailsEnabling: Details.Enabling) -> Self {
		.init(metaInfo: metaInfo, message: message, details: details?.moderated(detailsEnabling), configuration: configuration)
	}
	
	public func add (_ configuration: Configuration?) -> Self {
		.init(metaInfo: metaInfo, message: message, details: details, configuration: combine(self.configuration, configuration) { $0.combined(with: $1) })
	}
}
