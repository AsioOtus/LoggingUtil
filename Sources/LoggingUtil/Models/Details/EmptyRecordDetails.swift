public typealias EmptyDetails = EmptyRecordDetails

public struct EmptyRecordDetails: RecordDetails {
    public func combined (with: EmptyRecordDetails) -> EmptyRecordDetails { self }
    public func moderated (_ enabling: Bool) -> EmptyRecordDetails? { enabling ? self : nil }
}
