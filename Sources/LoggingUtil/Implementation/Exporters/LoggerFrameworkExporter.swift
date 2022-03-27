import os.log
import Combine

@available(iOS 14.0, macOS 11.0, *)
public class LoggerFrameworkExporter: Exporter {
	public var logger = os.Logger()
	
    public init () { }
	
	public func export (_ record: ExportRecord<String>) {
		switch record.metaInfo.level {
		case .trace:
			logger.trace("\(record.message)")
		case .debug:
			logger.debug("\(record.message)")
		case .info:
			logger.info("\(record.message)")
		case .notice:
			logger.notice("\(record.message)")
		case .warning:
			logger.warning("\(record.message)")
		case .error:
			logger.error("\(record.message)")
		case .critical:
			logger.critical("\(record.message)")
		case .fault:
			logger.fault("\(record.message)")
		}
	}
}

@available(iOS 14.0, macOS 11.0, *)
extension LoggerFrameworkExporter: Subscriber {
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

@available(iOS 14.0, macOS 11.0, *)
public extension Publisher {
    func loggerFrameworkExport () where Output == LoggerFrameworkExporter.Input, Failure == LoggerFrameworkExporter.Failure {
        receive(subscriber: LoggerFrameworkExporter())
    }
}

@available(iOS 14.0, macOS 11.0, *)
public extension AnyExporter {
	static var loggerFramework: AnyExporter<LoggerFrameworkExporter.Message> {
		LoggerFrameworkExporter().eraseToAnyExporter()
	}
}
