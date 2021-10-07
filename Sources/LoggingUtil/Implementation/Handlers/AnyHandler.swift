public struct AnyHandler <Message: Codable, Details: RecordDetails>: Handler {
	public let logging: (Record<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <H: Handler> (_ handler: H) where H.Message == Message, H.Details == Details {
		self.identificationInfo = handler.identificationInfo
		self.logging = handler.handle
	}
	
	public func handle (record: Record<Message, Details>) {
		logging(record)
	}
}

public extension Handler {
	func eraseToAnyHandler () -> AnyHandler<Message, Details> {
		AnyHandler(self)
	}
}

public extension AnyHandler {
	static func standard (
		_ handlers: [AnyHandler<Message, Details>] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self {
		StandardHandler(
			handlers,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func standard <H: Handler> (
		_ handler: H,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self where H.Message == Message, H.Details == Details {
		StandardHandler(
			handler,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func standard (
		_ handler: AnyHandler<Message, Details>,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self	{
		StandardHandler(
			handler,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func custom (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line,
		_ handling: @escaping (Record<Message, Details>) -> Void
	) -> Self {
		CustomHandler(
			label: label,
			file: file,
			line: line,
			handling
		)
		.eraseToAnyHandler()
	}
	
	static func custom (
		_ handlings: [(Record<Message, Details>) -> ()] = [],
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self {
		CustomHandler(
			handlings,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func plainConnector <Converter: PlainConverter> (
		_ converter: Converter,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	)
	-> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	{
		PlainConnector(
			converter: converter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
	
	static func supressErrorConnector <Converter: ThrowableConverter, E: Exporter> (
		_ converter: Converter,
		_ exporter: E,
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> AnyHandler<Converter.InputMessage, Converter.InputDetails>
	where Converter.OutputMessage == E.Message
	{
		ErrorSuppressingConnector(
			converter: converter,
			exporter: exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
}

@available(iOS 13, macOS 15.0, *)
extension AnyHandler {
	static func reactive (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) -> Self {
		ReactiveHandler(
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyHandler()
	}
}
