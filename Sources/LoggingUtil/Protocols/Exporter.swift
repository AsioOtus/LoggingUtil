public protocol Exporter {
	associatedtype Message
    
	func export (_ record: ExportRecord<Message>)
}
