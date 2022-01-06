import os.log
import Foundation
import Combine

@available(iOS 12.0, macOS 12.0, *)
public class OSLogExporter: Exporter {
	public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
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

extension OSLogExporter: Subscriber {
    public typealias Input = (metaInfo: MetaInfo, message: String)
    public typealias Failure = Never
    
    public func receive (subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func receive (_ input: Input) -> Subscribers.Demand {
        export(metaInfo: input.metaInfo, message: input.message)
        return .none
    }
    
    public func receive (completion: Subscribers.Completion<Never>) { }
}

public extension Publisher {
    func osLogExport () where Output == OSLogExporter.Input, Failure == OSLogExporter.Failure {
        receive(subscriber: OSLogExporter())
    }
}
