import Foundation

public struct IdentificationInfo: Codable, CustomStringConvertible {
	public let module: String?
	public let type: String
	public let definition: String
	public let instance: String
	public let label: String?
	public let extra: String?
	
	public var description: String {
		"\(module.flatMap{ "\($0)." } ?? "")\(type) – \(definition) – label: \(label.flatMap{ "\($0)." } ?? "") – \(instance) – \(extra)"
	}
	
	public var compactDescription: String {
		"\(module.flatMap{ "\($0)." } ?? "")\(type) – \(instance)"
	}
	
	public var typeDescription: String {
		"\(module.flatMap{ "\($0)." } ?? "")\(type)"
	}
	
	init (_ module: String? = nil, type: String, file: String, line: Int, label: String? = nil, extra: String? = nil) {
		self.module = module
		self.type = type
		self.definition = "\(file):\(line)"
		self.instance = UUID().uuidString
		self.label = label
		self.extra = extra
	}
}
