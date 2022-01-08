import Combine

public extension Publisher {
	@discardableResult
	func `switchMap` <Message, Details, MapMessage> (_ switchMap: SwitchMap<Message, Details, MapMessage>) -> AnyPublisher<(metaInfo: MetaInfo, message: MapMessage), Failure>
	where Output == Record<Message, Details>, Failure == Never
	{
		map { switchMap.map($0) }.eraseToAnyPublisher()
	}
}

public final class SwitchMap <Message: RecordMessage, Details: RecordDetails, Output> {
	public typealias Mapping = (LogRecord) -> Output
	public typealias LogRecord = Record<Message, Details>
	
	public var cases = [String: Mapping]()
	public let `default`: Mapping
	public let unknown : Mapping
	
	public init (default: @escaping Mapping, unknown: Mapping? = nil) {
		self.default = `default`
		self.unknown = unknown ?? `default`
	}
	
	public func map (_ record: Record<Message, Details>) -> (MetaInfo, Output) {
		let key = record.configuration?.keyValue[.switchMap]
		
		let output: Output
		if let mapping = cases.first(where: { $0.key == key })?.value {
			output = mapping(record)
		} else if key == nil {
			output = `default`(record)
		} else {
			output = unknown(record)
		}
		
		return (record.metaInfo, output)
	}
	
	@discardableResult
	public func `case` (_ key: String, _ mapping: @escaping Mapping) -> Self {
		cases[key] = mapping
		return self
	}
}

public extension SwitchMap {
	convenience init (default defaultConverter: AnyPlainConverter<Message, Details, Output>, unknown unknownConverter: AnyPlainConverter<Message, Details, Output>? = nil) {
		self.init(default: defaultConverter.convert(_:), unknown: unknownConverter?.convert(_:))
	}
	
	@discardableResult
	func `case` (_ key: String, _ mapping: AnyPlainConverter<Message, Details, Output>) -> Self {
		cases[key] = mapping.convert(_:)
		return self
	}
}

public extension Configuration.Key {
	static var `switchMap`: Self { "switchMap" }
}
