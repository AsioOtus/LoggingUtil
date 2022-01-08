import Combine

public extension Publisher {
    func isEnabled <Message, Details> (_ isEnabled: Bool = true) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { _ in isEnabled }.eraseToAnyPublisher()
    }
    
    func addDetails <Message, Details: RecordDetails> (_ details: Details) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        map { $0.add(details) }.eraseToAnyPublisher()
    }
    
    func detailsEnabling <Message, Details: RecordDetails> (_ enabling: Details.Enabling) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        map { $0.moderateDetails(enabling) }.eraseToAnyPublisher()
    }
	
	func clearDetails <Message, Details: RecordDetails> (_ isEnabled: Bool = true) -> AnyPublisher<Output, Failure>
	where Output == Record<Message, Details>, Failure == Never
	{
		map { isEnabled ? $0 : $0.details(nil) }.eraseToAnyPublisher()
	}
    
    func addConfiguration <Message, Details> (_ configuration: Configuration) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        map { $0.add(configuration) }.eraseToAnyPublisher()
    }
    
    func filterLevel <Message, Details> (_ level: Level) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { $0.metaInfo.level >= level }.eraseToAnyPublisher()
    }
    
    func filter <Message, Details> (_ predicate: @escaping Filter<Message, Details>) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { predicate($0) }.eraseToAnyPublisher()
    }
    
    func filter <Message, Details> (_ predicates: [Filter<Message, Details>]) -> AnyPublisher<Output, Failure>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { record in predicates.allSatisfy{ $0(record) } }.eraseToAnyPublisher()
    }
    
    func convert <Message, Details, OutputMessage> (_ converter: AnyPlainConverter<Message, Details, OutputMessage>) -> AnyPublisher<(metaInfo: MetaInfo, message: OutputMessage), Never>
    where
    Output == Record<Message, Details>,
    Failure == Never
    {
        map { ($0.metaInfo, converter.convert($0)) }.eraseToAnyPublisher()
    }
    
    func tryConvert <Message, Details, OutputMessage> (_ converter: AnyThrowableConverter<Message, Details, OutputMessage>) -> AnyPublisher<(metaInfo: MetaInfo, message: OutputMessage), Error>
    where Output == Record<Message, Details>
    {
        tryMap { ($0.metaInfo, try converter.tryConvert($0)) }.eraseToAnyPublisher()
    }
	
	@discardableResult
	func convertMessage <InputMessage, OutputMessage, Details> (_ mapping: @escaping (InputMessage) -> OutputMessage) -> AnyPublisher<Record<OutputMessage, Details>, Failure>
	where Output == Record<InputMessage, Details>, Failure == Never
	{
		map { $0.message(mapping($0.message)) }.eraseToAnyPublisher()
	}
	
	@discardableResult
	func convertDetails <InputDetails, OutputDetails, Message> (_ mapping: @escaping (InputDetails?) -> OutputDetails?) -> AnyPublisher<Record<Message, OutputDetails>, Failure>
	where Output == Record<Message, InputDetails>, Failure == Never
	{
		map { $0.details(mapping($0.details)) }.eraseToAnyPublisher()
	}
}
