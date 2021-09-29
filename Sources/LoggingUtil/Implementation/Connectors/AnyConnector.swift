public struct AnyConnector <Message: Codable, Details: RecordDetails>: Connector {
	public let logging: (Record<Message, Details>) -> Void
	
	public let identificationInfo: IdentificationInfo
	
	public init <C: Connector> (_ connector: C) where C.Message == Message, C.Details == Details {
		self.identificationInfo = connector.identificationInfo
		self.logging = connector.log
	}
	
	public func log (_ record: Record<Message, Details>) {
		logging(record)
	}
}

public extension AnyConnector {
	static func plain <Converter: PlainConverter, E: Exporter> (
		_ converter: Converter,
		_ exporter: E,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) -> AnyConnector<Converter.InputMessage, Converter.InputDetails>
	where Converter.OutputMessage == E.Message
	{
		PlainConnector(
			converter: converter,
			exporter: exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyConnector()
	}
	
	static func custom (
		_ connection: @escaping (Record<Message, Details>) -> Void,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) -> AnyConnector<Message, Details> {
		CustomConnector(
			label: label,
			file: file,
			line: line,
			connection
		)
		.eraseToAnyConnector()
	}
	
	static func supressError <Converter: ThrowableConverter, E: Exporter> (
		_ converter: Converter,
		_ exporter: E,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) -> AnyConnector<Converter.InputMessage, Converter.InputDetails>
	where Converter.OutputMessage == E.Message
	{
		ErrorSuppressingConnector(
			converter: converter,
			exporter: exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyConnector()
	}
	
	static func transparent <Message: Codable, Details: RecordDetails, E: Exporter> (
		_ exporter: E,
		label: String? = nil,
		file: String = #file,
		line: Int = #line
	) -> AnyConnector<Message, Details>
	where E.Message == Record<Message, Details>
	{
		TransparentConnector(
			exporter,
			label: label,
			file: file,
			line: line
		)
		.eraseToAnyConnector()
	}
}

public extension Connector {
	func eraseToAnyConnector () -> AnyConnector<Message, Details> {
		AnyConnector(self)
	}
}
