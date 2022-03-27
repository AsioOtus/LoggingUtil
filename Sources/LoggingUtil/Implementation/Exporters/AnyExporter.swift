import Combine

public struct AnyExporter <Message>: Exporter {
	public let exporting: (ExportRecord<Message>) -> Void
	
	public init <E: Exporter> (_ exporter: E) where E.Message == Message {
		self.exporting = exporter.export
	}
	
	public func export (_ record: ExportRecord<Message>) {
		exporting(record)
	}
}

extension AnyExporter: Subscriber {
	public var combineIdentifier: CombineIdentifier { .init() }
	
	public typealias Input = ExportRecord<Message>
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

public extension Exporter {
	func eraseToAnyExporter () -> AnyExporter<Message> {
		AnyExporter(self)
	}
}
