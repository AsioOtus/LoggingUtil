import Combine

public extension Publisher {
    func isEnabled <Message, Details> (_ isEnabled: Bool = true) -> Publishers.Filter<Self>
    where Output == Record<Message, Details>, Failure == Never
    {
		filter { _ in isEnabled }
    }
    
    func addDetails <Message, Details: RecordDetails> (_ details: Details) -> Publishers.Map<Self, Record<Message, Details>>
    where Output == Record<Message, Details>, Failure == Never
    {
        map { $0.add(details) }
    }
    
    func detailsEnabling <Message, Details: RecordDetails> (_ enabling: Details.Enabling) -> Publishers.Map<Self, Record<Message, Details>>
    where Output == Record<Message, Details>, Failure == Never
    {
        map { $0.moderateDetails(enabling) }
    }
	
	func clearDetails <Message, Details: RecordDetails> (_ isEnabled: Bool = true) -> Publishers.Map<Self, Record<Message, Details>>
	where Output == Record<Message, Details>, Failure == Never
	{
		map { isEnabled ? $0 : $0.details(nil) }
	}
    
    func addConfiguration <Message, Details> (_ configuration: Configuration) -> Publishers.Map<Self, Record<Message, Details>>
    where Output == Record<Message, Details>, Failure == Never
    {
        map { $0.add(configuration) }
    }
    
    func filterLevel <Message, Details> (_ level: Level) -> Publishers.Filter<Self>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { $0.metaInfo.level >= level }
    }
    
    func filter <Message, Details> (_ predicate: @escaping Filter<Message, Details>) -> Publishers.Filter<Self>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { predicate($0) }
    }
    
    func filter <Message, Details> (_ predicates: [Filter<Message, Details>]) -> Publishers.Filter<Self>
    where Output == Record<Message, Details>, Failure == Never
    {
        filter { record in predicates.allSatisfy{ $0(record) } }
    }
    
    func convert <Message, Details, OutputMessage> (_ converter: AnyPlainConverter<Message, Details, OutputMessage>) -> Publishers.Map<Self, (metaInfo: MetaInfo, message: OutputMessage)>
    where
    Output == Record<Message, Details>,
    Failure == Never
    {
        map { ($0.metaInfo, converter.convert($0)) }
    }
    
    func tryConvert <Message, Details, OutputMessage> (_ converter: AnyThrowableConverter<Message, Details, OutputMessage>) -> Publishers.TryMap<Self, (metaInfo: MetaInfo, message: OutputMessage)>
    where Output == Record<Message, Details>
    {
        tryMap { ($0.metaInfo, try converter.tryConvert($0)) }
    }
	
	@discardableResult
	func convertMessage <InputMessage, OutputMessage, Details> (_ mapping: @escaping (InputMessage) -> OutputMessage) -> Publishers.Map<Self, Record<OutputMessage, Details>>
	where Output == Record<InputMessage, Details>, Failure == Never
	{
		map { $0.message(mapping($0.message)) }
	}
	
	@discardableResult
	func convertDetails <InputDetails, OutputDetails, Message> (_ mapping: @escaping (InputDetails?) -> OutputDetails?) -> Publishers.Map<Self, Record<Message, OutputDetails>>
	where Output == Record<Message, InputDetails>, Failure == Never
	{
		map { $0.details(mapping($0.details)) }
	}
}
