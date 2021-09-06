import Foundation

public extension MultilineStringLogExporterAdapter {
	struct Configuration {
		public static var defaultDateFormatter: DateFormatter {
			let formatter = DateFormatter()
			formatter.dateStyle = .short
			return formatter
		}
		
		public var metaInfoEnabling: MetaInfo.Enabling = .enabled()
		public var detailsEnabling: StandardLogRecordDetails.Enabling = .enabled()
		public var levelPadding: Bool = true
		public var componentsSeparator: String = " | "
		public var dateFormatter: DateFormatter = defaultDateFormatter
		
		public init () { }
		
		func metaInfoEnabling (_ metaInfoEnabling: MetaInfo.Enabling) -> Self {
			var selfCopy = self
			selfCopy.metaInfoEnabling = metaInfoEnabling
			return self
		}
		
		func detailsEnabling (_ detailsEnabling: StandardLogRecordDetails.Enabling) -> Self {
			var selfCopy = self
			selfCopy.detailsEnabling = detailsEnabling
			return self
		}
		
		func levelPadding (_ levelPadding: Bool) -> Self {
			var selfCopy = self
			selfCopy.levelPadding = levelPadding
			return self
		}
		
		func componentsSeparator (_ componentsSeparator: String) -> Self {
			var selfCopy = self
			selfCopy.componentsSeparator = componentsSeparator
			return self
		}
		
		func dateFormatter (_ dateFormatter: DateFormatter) -> Self {
			var selfCopy = self
			selfCopy.dateFormatter = dateFormatter
			return self
		}
	}
}

public struct MultilineStringLogExporterAdapter <LogExporterType: LogExporter>: StringLogExporterAdapter where LogExporterType.Message == String {
	public var logExporter: LogExporterType
	public var configuration: Configuration
	
	public init (_ logExporter: LogExporterType, configuration: Configuration = .init()) {
		self.logExporter = logExporter
		self.configuration = configuration
	}
	
	public func adapt (logRecord: LogRecord<String, StandardLogRecordDetails>) {
		let logRecordDetails = logRecord.details?.moderated(configuration.detailsEnabling)
		
		var messageHeaderComponents = [String]()
		
		if case let .enabled(timestamp: isTimestampEnabled, _, _) = configuration.metaInfoEnabling, isTimestampEnabled {
			let formattedDate = configuration.dateFormatter.string(from: Date(timeIntervalSince1970: logRecord.metaInfo.timestamp))
			messageHeaderComponents.append(formattedDate)
		}
		
		if case let .enabled(_, level: isLevelEnabled, _) = configuration.metaInfoEnabling, isLevelEnabled {
			messageHeaderComponents.append(configuration.levelPadding
				? logRecord.metaInfo.level.logDescription.padding(toLength: LogLevel.critical.logDescription.count, withPad: " ", startingAt: 0)
				: logRecord.metaInfo.level.logDescription
			)
		}
		
		if let tags = logRecordDetails?.tags, !tags.isEmpty {
			messageHeaderComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecordDetails?.source, !source.isEmpty {
			messageHeaderComponents.append(source.combine(with: "."))
		}
		
		let messageHeader = messageHeaderComponents.combine(with: configuration.componentsSeparator)
		
		var messageComponents = [String]()
		
		messageComponents.append(messageHeader)
		messageComponents.append(logRecord.message)
		
		if let keyValue = logRecordDetails?.keyValue, !keyValue.isEmpty {
			messageComponents.append("\(keyValue)")
		}
		
		if let comment = logRecordDetails?.comment, !comment.isEmpty {
			messageComponents.append(comment)
		}
		
		messageComponents.append("\n")
		
		let finalMessage = messageComponents.combine(with: "\n")
		
		logExporter.log(metaInfo: logRecord.metaInfo, message: finalMessage)
	}
}



fileprivate extension LogLevel {
	var logDescription: String { self.rawValue.uppercased() }
}



fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
