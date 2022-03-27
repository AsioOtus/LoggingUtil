import Foundation

public struct StringToJSONDataConverter: ThrowableConverter {
	public typealias InputMessage = String
	public typealias InputDetails = StandardRecordDetails
	public typealias OutputMessage = Data
	
	public var jsonEncoder: JSONEncoder
	
    public init (jsonEncoder: JSONEncoder = .init()) {
		self.jsonEncoder = jsonEncoder
	}
	
	public func tryConvert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage { try jsonEncoder.encode(record) }
}

public extension AnyThrowableConverter {
	static func stringToJsonDataConverter (jsonEncoder: JSONEncoder = .init()) -> AnyThrowableConverter<StringToJSONDataConverter.InputMessage, StringToJSONDataConverter.InputDetails, StringToJSONDataConverter.OutputMessage> {
		StringToJSONDataConverter(jsonEncoder: jsonEncoder).eraseToAnyThrowableConverter()
	}
}
