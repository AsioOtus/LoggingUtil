public struct SingleLineConverter: PlainLogConverter {
	public var metaInfoEnabling = MetaInfo.Enabling.enabled()
	public var detailsEnabling = StandardLogRecordDetails.Enabling.enabled()
	public var levelPadding = true
	public var componentsSeparator = " | "
	
	public init () { }
	
	public func convert (_ logRecord: LogRecord<String, StandardLogRecordDetails>) -> String {
		let logRecordDetails = logRecord.details?.moderated(detailsEnabling)
		
		var messageComponents = [String]()
		
		if case let .enabled(_, level: isLevelEnabled, _) = metaInfoEnabling, isLevelEnabled {
			messageComponents.append(levelPadding
										? logRecord.metaInfo.level.logDescription.padding(toLength: LogLevel.critical.logDescription.count, withPad: " ", startingAt: 0)
										: logRecord.metaInfo.level.logDescription
			)
		}
		
		if let tags = logRecordDetails?.tags, !tags.isEmpty {
			messageComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = logRecordDetails?.source, !source.isEmpty {
			messageComponents.append(source.combine(with: "."))
		}
		
		messageComponents.append(logRecord.message)
		
		if let keyValue = logRecordDetails?.keyValue, !keyValue.isEmpty {
			messageComponents.append("\(keyValue)")
		}
		
		if let comment = logRecordDetails?.comment, !comment.isEmpty {
			messageComponents.append(comment)
		}
		
		let finalMessage = messageComponents.combine(with: componentsSeparator)
		return finalMessage
	}
}

extension SingleLineConverter {
	@discardableResult
	public func metaInfoEnabling (_ metaInfoEnabling: MetaInfo.Enabling) -> Self {
		var selfCopy = self
		selfCopy.metaInfoEnabling = metaInfoEnabling
		return self
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: StandardLogRecordDetails.Enabling) -> Self {
		var selfCopy = self
		selfCopy.detailsEnabling = detailsEnabling
		return selfCopy
	}
	
	@discardableResult
	public func levelPadding (_ levelPadding: Bool) -> Self {
		var selfCopy = self
		selfCopy.levelPadding = levelPadding
		return selfCopy
	}
	
	@discardableResult
	public func componentsSeparator (_ componentsSeparator: String) -> Self {
		var selfCopy = self
		selfCopy.componentsSeparator = componentsSeparator
		return selfCopy
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
