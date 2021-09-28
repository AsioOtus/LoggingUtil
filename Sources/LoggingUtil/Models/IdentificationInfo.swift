import Foundation

public struct IdentificationInfo: Codable, CustomStringConvertible {
	public let module: String?
	public let type: String
	public let definition: String
	public let instance: String
	public let alias: String?
	
	public var description: String {
		"\(module.flatMap{ "\($0)." } ?? "")\(type) – \(definition) – alias: \(alias.flatMap{ "\($0)." } ?? "") – \(instance)"
	}
	
	public var shortDescription: String {
		"\(module.flatMap{ "\($0)." } ?? "")\(type) – \(instance)"
	}
	
	public var typeDescription: String {
		"\(module.flatMap{ "\($0)." } ?? "")\(type)"
	}
	
	init (_ module: String? = nil, type: String, file: String, line: Int, alias: String? = nil) {
		self.module = module
		self.type = type
		self.definition = "\(file):\(line)"
		self.instance = UUID().uuidString
		self.alias = alias
	}
}
