import Foundation

public struct StringToJSONDataConverter: ThrowableConverter {	
	public var jsonEncoder: JSONEncoder
	
	public init (jsonEncoder: JSONEncoder = JSONEncoder()) {
		self.jsonEncoder = jsonEncoder
	}
	
	public func convert (_ record: Record<String, StandardRecordDetails>) throws -> Data {
		try jsonEncoder.encode(record)
	}
}
