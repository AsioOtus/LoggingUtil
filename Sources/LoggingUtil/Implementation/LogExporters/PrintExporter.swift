public class PrintExporter: ConfigurableLogExporter {
	public var isEnabled = true
	public var level: LogLevel = .trace
	
	public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
		guard isEnabled, metaInfo.level <= level else { return }
		print(message)
	}
}
