import Foundation

public struct StringToJSONDataConverter: ThrowableConverter {	
	public var jsonEncoder: JSONEncoder
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		jsonEncoder: JSONEncoder = JSONEncoder(),
		alias: String? = nil,
		file: String = #file,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, alias: alias)
		self.jsonEncoder = jsonEncoder
	}
	
	public func convert (_ record: Record<String, StandardRecordDetails>) throws -> Data { try jsonEncoder.encode(record) }
}
