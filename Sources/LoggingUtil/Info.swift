public struct Info {
	public static let moduleName = "LoggingUtil"
	
	static func prefixed (_ string: String) -> String {
		"\(moduleName).\(string)"
	}
}
