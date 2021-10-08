import Foundation

public struct SingleLineConverter: PlainConverter {
	public static var defaultDateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
		return formatter
	}
	
	public var metaInfoEnabling = MetaInfo.Enabling.enabled()
	public var detailsEnabling = StandardRecordDetails.Enabling.defaultEnabling
	public var levelPadding = true
	public var componentsSeparator = " | "
	public var dateFormatter: DateFormatter = defaultDateFormatter
	
	public let identificationInfo: IdentificationInfo
	
	public init (
		label: String? = nil,
		file: String = #fileID,
		line: Int = #line
	) {
		self.identificationInfo = .init(type: String(describing: Self.self), file: file, line: line, label: label)
	}
	
	public func convert (_ record: Record<String, StandardRecordDetails>) -> String {
		let recordDetails = record.details?.moderated(detailsEnabling)
		
		var messageComponents = [String]()
		
		if case let .enabled(isTimestampEnabled, _, _, _, _) = metaInfoEnabling, isTimestampEnabled {
			let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: record.metaInfo.timestamp))
			messageComponents.append(formattedDate)
		}
		
		if case let .enabled(_, level: isLevelEnabled, _, _, _) = metaInfoEnabling, isLevelEnabled {
			messageComponents.append(levelPadding
										? record.metaInfo.level.logDescription.padding(toLength: Level.critical.logDescription.count, withPad: " ", startingAt: 0)
										: record.metaInfo.level.logDescription
			)
		}
		
		if let source = recordDetails?.source, !source.isEmpty {
			messageComponents.append(source.combine(with: "."))
		}

		if let tags = recordDetails?.tags, !tags.isEmpty {
			messageComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		messageComponents.append(record.message)
		
		if let keyValue = recordDetails?.keyValue, !keyValue.isEmpty {
			messageComponents.append("\(keyValue)")
		}
		
		if let comment = recordDetails?.comment, !comment.isEmpty {
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
