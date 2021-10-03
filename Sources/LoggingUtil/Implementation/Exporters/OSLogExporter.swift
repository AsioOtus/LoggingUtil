import os.log
import Foundation

@available(iOS 12.0, macOS 12.0, *)
public class OSLogExporter: CustomizableExporter {
	public var isEnabled = true
	public var level: Level = .trace
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
	
	public func export (metaInfo: MetaInfo, message: String) {
		guard isEnabled, metaInfo.level >= level else { return }
		
		let osLogType = levelToOsLogType(metaInfo.level)
		os_log(osLogType, "%@", message as NSString)
	}
	
	private func levelToOsLogType (_ level: Level) -> OSLogType {
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
