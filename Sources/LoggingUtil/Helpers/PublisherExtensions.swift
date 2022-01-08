import Combine

public extension Publisher {
    func bind <S: Subject> (to subject: S) -> AnyCancellable where S.Output == Output, S.Failure == Failure {
        sink(
            receiveCompletion: { subject.send(completion: $0) },
            receiveValue: { subject.send($0) }
        )
    }
}
