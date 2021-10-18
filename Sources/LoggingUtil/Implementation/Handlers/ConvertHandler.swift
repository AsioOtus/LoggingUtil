public class ConvertHandler <Converter: PlainConverter>: IsEnabledCustomizable where Converter.OutputMessage: Codable {
	public typealias Message = Converter.InputMessage
	public typealias Details = Converter.InputDetails
	public typealias OutputMessage = Converter.OutputMessage
	
	public var isEnabled = true
	
	public let converter: Converter
	public var handlers = [AnyHandler<OutputMessage, Details>]()
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		converter: Converter,
		handlers: [AnyHandler<OutputMessage, Details>],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		
		self.converter = converter
		self.handlers = handlers
	}
	
	public convenience init (
		converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		@ArrayBuilder _ handlers: () -> [AnyHandler<OutputMessage, Details>]
	) {
		self.init(converter: converter, handlers: handlers(), label: label, file: file, line: line)
	}
	
	public convenience init (
		_ converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(converter: converter, handlers: [], label: label, file: file, line: line)
	}
	
	public convenience init <H: Handler> (
		converter: Converter,
		handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	where H.Message == OutputMessage, H.Details == Details
	{
		self.init(converter: converter, handlers: [handler.eraseToAnyHandler()], label: label, file: file, line: line)
	}
	
	public convenience init (
		converter: Converter,
		handler: AnyHandler<OutputMessage, Details>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.init(converter: converter, handlers: [handler], label: label, file: file, line: line)
	}
}

extension ConvertHandler: Handler {
	public func handle (record: Record<Message, Details>) {
		guard isEnabled else { return }
		
		let record = record
			.add(identificationInfo)
			.add(converter.identificationInfo)
		
		for handler in handlers {
			let record = record
				.add(handler.identificationInfo)
			
			let message = converter.convert(record)
			handler.handle(record: .init(metaInfo: record.metaInfo, message: message, details: record.details, configuration: record.configuration))
		}
	}
}

public extension ConvertHandler {
	@discardableResult
	func handler <H: Handler> (_ handler: H) -> Self where H.Message == OutputMessage, H.Details == Details {
		self.handlers.append(handler.eraseToAnyHandler())
		return self
	}
	
	@discardableResult
	func handler (_ handler: AnyHandler<OutputMessage, Details>) -> Self {
		self.handlers.append(handler)
		return self
	}
	
	@discardableResult
	func handler (@ArrayBuilder _ handlers: () -> [AnyHandler<OutputMessage, Details>]) -> Self {
		self.handlers.append(contentsOf: handlers())
		return self
	}
}

public extension AnyHandler {
	static func converter <Converter: PlainConverter> (
		converter: Converter,
		handlers: [AnyHandler<Converter.OutputMessage, Converter.InputDetails>],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	{
		ConvertHandler(
			converter: converter,
			handlers: handlers,
			label: label,
			file: file,
			line: line
		)
			.eraseToAnyHandler()
	}

	static func converter <Converter: PlainConverter> (
		_ converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	where Converter.OutputMessage: Codable
	{
		ConvertHandler(
			converter,
			label: label,
			file: file,
			line: line
		)
			.eraseToAnyHandler()
	}

	static func converter <Converter: PlainConverter, H: Handler> (
		converter: Converter,
		handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	where H.Message == Converter.OutputMessage, H.Details == Converter.InputDetails
	{
		ConvertHandler(
			converter: converter,
			handler: handler,
			label: label,
			file: file,
			line: line
		)
			.eraseToAnyHandler()
	}

	static func converter <Converter: PlainConverter> (
		converter: Converter,
		handler: AnyHandler<Converter.OutputMessage, Converter.InputDetails>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	{
		ConvertHandler(
			converter: converter,
			handler: handler,
			label: label,
			file: file,
			line: line
		)
			.eraseToAnyHandler()
	}
}
