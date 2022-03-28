import Combine

public extension Publisher {
    func log <S: Subject, Message: RecordMessage, Details: RecordDetails> (to subject: S) -> AnyCancellable
    where
    S.Output == Record<Message, Details>,
    S.Output == Output,
    S.Failure == Failure
    {
        sink(
            receiveCompletion: { subject.send(completion: $0) },
            receiveValue: { subject.send($0) }
        )
    }
}
