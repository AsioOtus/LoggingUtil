import os.log

@available(iOS 14.0, macOS 11.0, *)
public class LoggerFrameworkExporter: ConfigurableExporter {
	public var isEnabled = true
	public var level: Level = .trace
	
	public var logger = os.Logger()
	
	public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
		guard isEnabled, metaInfo.level >= level else { return }
		
		switch metaInfo.level {
		case .trace:
			logger.trace("\(message)")
		case .debug:
			logger.debug("\(message)")
		case .info:
			logger.info("\(message)")
		case .notice:
			logger.notice("\(message)")
		case .warning:
			logger.warning("\(message)")
		case .error:
			logger.error("\(message)")
		case .critical:
			logger.critical("\(message)")
		case .fault:
			logger.fault("\(message)")
		}
	}
}