import Foundation

public struct StringToJSONDataConverter: ThrowableLogConverter {	
	public var jsonEncoder: JSONEncoder
	
	public init (jsonEncoder: JSONEncoder = JSONEncoder()) {
		self.jsonEncoder = jsonEncoder
	}
	
	public func convert (_ logRecord: LogRecord<String, StandardLogRecordDetails>) throws -> Data {
		try jsonEncoder.encode(logRecord)
	}
}
