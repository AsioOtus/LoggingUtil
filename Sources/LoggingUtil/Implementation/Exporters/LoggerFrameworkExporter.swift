import os.log
import Combine

@available(iOS 14.0, macOS 11.0, *)
public class LoggerFrameworkExporter: Exporter {
	public var logger = os.Logger()
	
    public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
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

@available(iOS 14.0, macOS 11.0, *)
extension LoggerFrameworkExporter: Subscriber {
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

@available(iOS 14.0, macOS 11.0, *)
public extension Publisher {
    func loggerFrameworkExport () where Output == LoggerFrameworkExporter.Input, Failure == LoggerFrameworkExporter.Failure {
        receive(subscriber: LoggerFrameworkExporter())
    }
}

