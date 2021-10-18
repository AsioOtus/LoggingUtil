import Foundation

public struct StringToJSONDataConverter: ThrowableConverter {
	public typealias InputMessage = String
	public typealias InputDetails = StandardRecordDetails
	public typealias OutputMessage = Data
	
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
	
	public func tryConvert (_ record: Record<InputMessage, InputDetails>) throws -> OutputMessage { try jsonEncoder.encode(record) }
}
