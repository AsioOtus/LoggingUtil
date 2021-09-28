import Foundation

public struct MultilineConverter: PlainConverter {
	public static var defaultDateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter
	}
	
	public var metaInfoEnabling: MetaInfo.Enabling = .enabled()
	public var detailsEnabling: StandardRecordDetails.Enabling = .enabled()
	public var levelPadding: Bool = true
	public var componentsSeparator: String = " | "
	public var dateFormatter: DateFormatter = defaultDateFormatter
	
	public init () { }
	
	public func convert (_ record: Record<String, StandardRecordDetails>) -> String {
		let recordDetails = record.details?.moderated(detailsEnabling)
		
		var messageHeaderComponents = [String]()
		
		if case let .enabled(timestamp: isTimestampEnabled, _, _) = metaInfoEnabling, isTimestampEnabled {
			let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: record.metaInfo.timestamp))
			messageHeaderComponents.append(formattedDate)
		}
		
		if case let .enabled(_, level: isLevelEnabled, _) = metaInfoEnabling, isLevelEnabled {
			messageHeaderComponents.append(levelPadding
											? record.metaInfo.level.logDescription.padding(toLength: Level.critical.logDescription.count, withPad: " ", startingAt: 0)
											: record.metaInfo.level.logDescription
			)
		}
		
		if let tags = recordDetails?.tags, !tags.isEmpty {
			messageHeaderComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		if let source = recordDetails?.source, !source.isEmpty {
			messageHeaderComponents.append(source.combine(with: "."))
		}
		
		let messageHeader = messageHeaderComponents.combine(with: componentsSeparator)
		
		var messageComponents = [String]()
		
		messageComponents.append(messageHeader)
		messageComponents.append(record.message)
		
		if let keyValue = recordDetails?.keyValue, !keyValue.isEmpty {
			messageComponents.append("\(keyValue)")
		}
		
		if let comment = recordDetails?.comment, !comment.isEmpty {
			messageComponents.append(comment)
		}
		
		messageComponents.append("\n")
		
		let finalMessage = messageComponents.combine(with: "\n")
		return finalMessage
	}
}

extension MultilineConverter {
	@discardableResult
	public func metaInfoEnabling (_ metaInfoEnabling: MetaInfo.Enabling) -> Self {
		var selfCopy = self
		selfCopy.metaInfoEnabling = metaInfoEnabling
		return selfCopy
	}
	
	@discardableResult
	public func detailsEnabling (_ detailsEnabling: StandardRecordDetails.Enabling) -> Self {
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
	
	@discardableResult
	public func dateFormatter (_ dateFormatter: DateFormatter) -> Self {
		var selfCopy = self
		selfCopy.dateFormatter = dateFormatter
		return selfCopy
	}
	
	@discardableResult
	public func updateDateFormatter (_ dateFormatterUpdating: (DateFormatter) -> ()) -> Self {
		dateFormatterUpdating(dateFormatter)
		return self
	}
}



fileprivate extension Level {
	var logDescription: String { self.rawValue.uppercased() }
}

fileprivate extension Array where Element == String {
	func combine (with separator: String) -> String {
		let preparedSources = self.compactMap{ $0 }.filter { !$0.isEmpty }
		return preparedSources.joined(separator: separator)
	}
}
