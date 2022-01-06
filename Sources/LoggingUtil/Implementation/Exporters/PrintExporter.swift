import Combine

public class PrintExporter: Exporter {
    public init () { }
	
	public func export (metaInfo: MetaInfo, message: String) {
		print(message)
	}
}

extension PrintExporter: Subscriber {
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
    func printExport () where Output == PrintExporter.Input, Failure == PrintExporter.Failure {
        receive(subscriber: PrintExporter())
    }
}

