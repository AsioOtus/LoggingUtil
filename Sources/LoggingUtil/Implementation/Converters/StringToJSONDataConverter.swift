import Foundation

public struct StringToJSONDataConverter: ThrowableConverter {	
	public var jsonEncoder: JSONEncoder
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		jsonEncoder: JSONEncoder = JSONEncoder(),
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
		self.jsonEncoder = jsonEncoder
	}
	
	public func convert (_ record: Record<String, StandardRecordDetails>) throws -> Data { try jsonEncoder.encode(record) }
}
