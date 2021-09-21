import Foundation

struct LabelBuilder {
	private init () { }
	
	static func build (_ itemType: String, _ file: String, _ line: Int, _ identifier: String) -> String {
		"\(Info.moduleName).\(itemType) – \(file):\(line) – \(identifier)"
	}
}
