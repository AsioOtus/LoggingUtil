import Foundation
import Combine

public class StandardLogger <Message: Codable, Details: RecordDetails> {
    private let subject = PassthroughSubject<Record<Message, Details>, Never>()
    
    public init () { }
}

extension StandardLogger: Subject {
    public typealias Output = Record<Message, Details>
    public typealias Failure = Never
    
    public func send (_ value: Output) {
        subject.send(value)
    }
    
    public func send (completion: Subscribers.Completion<Failure>) {
        subject.send(completion: completion)
    }
    
    public func send (subscription: Subscription) {
        subject.send(subscription: subscription)
    }
    
    public func receive <Downstream: Subscriber> (subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        subject.subscribe(subscriber)
    }
}

extension StandardLogger: Logger {
	public func log (level: Level, message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
        let metaInfo = MetaInfo.now(level: level, label: label, file: file, line: line)
		let record = Record(metaInfo: metaInfo, message: message, details: details, configuration: configuration)
		
        subject.send(record)
	}
}





public class StandardHandler <Message: Codable, Details: RecordDetails> {
    
}
