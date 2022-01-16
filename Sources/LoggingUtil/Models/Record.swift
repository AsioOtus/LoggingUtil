extension Record: Codable {
	public enum CodingKeys: String, CodingKey {
		case metaInfo
		case message
		case details
	}
	
	public init (from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
		let metaInfo = try values.decode(MetaInfo.self, forKey: .metaInfo)
		let message = try values.decode(Message.self, forKey: .message)
		let details = try values.decode(Details.self, forKey: .details)
		
		self.init(metaInfo: metaInfo, message: message, details: details)
	}
}

public struct Record <Message: RecordMessage, Details: RecordDetails> {
	public let metaInfo: MetaInfo
	public let message: Message
	public let details: Details?
	public let configuration: Configuration?
	
	public init (metaInfo: MetaInfo, message: Message, details: Details?, configuration: Configuration? = nil) {
		self.metaInfo = metaInfo
		self.message = message
		self.details = details
		self.configuration = configuration
	}
	
    public static func now (level: Level, message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String, line: Int) -> Self {
        let metaInfo = MetaInfo.now(level: level, label: label, file: file, line: line)
        let record = Record(metaInfo: metaInfo, message: message, details: details, configuration: configuration)
        return record
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
	
	public func message <NewMessage: Codable> (_ message: NewMessage) -> Record<NewMessage, Details> {
		.init(metaInfo: metaInfo, message: message, details: details, configuration: configuration)
	}
	
	public func details <NewDetails: RecordDetails> (_ details: NewDetails?) -> Record<Message, NewDetails> {
		.init(metaInfo: metaInfo, message: message, details: details, configuration: configuration)
	}
}
