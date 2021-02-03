import os.log
import Foundation

@available(iOS 12.0, *)
public class OsLogLogExporter: LogExporter {
	public init () { }
	
	public func log (_ level: LoggingLevel, _ message: String) {
		let osLogType = logLevelToOsLogType(level)
		os_log(osLogType, "%@", message as NSString)
	}
	
	private func logLevelToOsLogType (_ level: LoggingLevel) -> OSLogType {
		let osLogType: OSLogType
		
		switch level {
		case .trace:
			osLogType = .debug
		case .debug:
			osLogType = .debug
		case .info:
			osLogType = .info
		case .notice:
			osLogType = .default
		case .warning:
			osLogType = .default
		case .error:
			osLogType = .fault
		case .critical:
			osLogType = .fault
		case .fault:
			osLogType = .fault
		}
		
		return osLogType
	}
}