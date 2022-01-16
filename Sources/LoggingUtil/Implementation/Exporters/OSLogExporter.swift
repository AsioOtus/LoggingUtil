import os.log
import Foundation
import Combine

@available(iOS 12.0, macOS 12.0, *)
public class OSLogExporter: Exporter {
	public init () { }
	
	public func export (_ record: ExportRecord<String>) {
		let osLogType = levelToOsLogType(record.metaInfo.level)
		os_log(osLogType, "%@", record.message as NSString)
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

@available(iOS 12.0, macOS 12.0, *)
extension OSLogExporter: Subscriber {
    public typealias Input = ExportRecord<String>
    public typealias Failure = Never
    
    public func receive (subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive (_ input: Input) -> Subscribers.Demand {
        export(input)
        return .none
    }
    
    public func receive (completion: Subscribers.Completion<Never>) { }
}

@available(iOS 12.0, macOS 12.0, *)
public extension Publisher {
    func osLogExport () where Output == OSLogExporter.Input, Failure == OSLogExporter.Failure {
        receive(subscriber: OSLogExporter())
    }
}
