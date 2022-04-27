public protocol Logger {
	associatedtype Message: RecordMessage
	associatedtype Details: RecordDetails
	
	func log (level: Level, message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	
	func trace    (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func debug    (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func info     (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func notice   (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func warning  (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func fault    (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func error    (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
	func critical (_ message: Message, details: Details?, configuration: Configuration?, label: String?, file: String, line: Int)
}

public extension Logger {
	func trace    (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .trace,    message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func debug    (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .debug,    message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func info     (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .info,     message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func notice   (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .notice,   message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func warning  (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .warning,  message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func fault    (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .fault,    message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func error    (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .error,    message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
	
	func critical (_ message: Message, details: Details? = nil, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .critical, message: message, details: details, configuration: configuration, label: label, file: file, line: line)
	}
}

public extension Logger {
	func trace    (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .trace,    message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func debug    (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .debug,    message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func info     (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .info,     message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func notice   (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .notice,   message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func warning  (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .warning,  message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func fault    (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .fault,    message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func error    (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .error,    message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
	
	func critical (_ message: Message, details: Details? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .critical, message: message, details: details, configuration: nil, label: nil, file: file, line: line)
	}
}

public extension Logger where Details == EmptyRecordDetails {
	func trace    (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .trace,    message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func debug    (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .debug,    message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func info     (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .info,     message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func notice   (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .notice,   message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func warning  (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .warning,  message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func fault    (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .fault,    message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func error    (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .error,    message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
	
	func critical (_ message: Message, configuration: Configuration? = nil, label: String? = nil, file: String = #fileID, line: Int = #line) {
		log(level: .critical, message: message, details: nil, configuration: configuration, label: label, file: file, line: line)
	}
}

public extension Logger where Details == EmptyRecordDetails {
	func trace    (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .trace,    message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func debug    (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .debug,    message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func info     (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .info,     message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func notice   (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .notice,   message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func warning  (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .warning,  message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func fault    (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .fault,    message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func error    (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .error,    message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
	
	func critical (_ message: Message, file: String = #fileID, line: Int = #line) {
		log(level: .critical, message: message, details: nil, configuration: nil, label: nil, file: file, line: line)
	}
}
