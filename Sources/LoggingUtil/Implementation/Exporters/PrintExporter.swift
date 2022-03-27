import Combine

public class PrintExporter: Exporter {
    public init () { }
	
	public func export (_ record: ExportRecord<String>) {
		print(record.message)
	}
}

extension PrintExporter: Subscriber {
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

public extension Publisher {
    func printExport () where Output == PrintExporter.Input, Failure == PrintExporter.Failure {
        receive(subscriber: PrintExporter())
    }
}

public extension AnyExporter {
	static var printExporter: AnyExporter<PrintExporter.Message> {
		PrintExporter().eraseToAnyExporter()
	}
}
