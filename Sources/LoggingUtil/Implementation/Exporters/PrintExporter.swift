public class PrintExporter: ConfigurableExporter {
	public var isEnabled = true
	public var level: Level = .trace
	
	public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
		guard isEnabled, metaInfo.level >= level else { return }
		print(message)
	}
}
