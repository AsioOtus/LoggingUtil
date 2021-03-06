import Foundation
import Combine

public struct MultilineConverter: PlainConverter {
	public typealias InputMessage = String
	public typealias InputDetails = CompactRecordDetails
	public typealias OutputMessage = String
	
	public static var defaultDateFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
		return formatter
	}
	
	public var metaInfoEnabling: MetaInfo.Enabling = .enabled()
	public var detailsEnabling: InputDetails.Enabling = .defaultEnabling
	public var levelPadding: Bool = true
	public var componentsSeparator: String = " | "
	public var dateFormatter: DateFormatter = defaultDateFormatter
	
    public init () { }
	
	public func convert (_ record: Record<String, InputDetails>) -> OutputMessage {
		let recordDetails = record.details?.moderated(detailsEnabling)
		
		var messageHeaderComponents = [String]()

		if let prefix = recordDetails?.prefix, !prefix.isEmpty {
			messageHeaderComponents.append(prefix)
		}

		if case let .enabled(timestamp: isTimestampEnabled, _, _, _) = metaInfoEnabling, isTimestampEnabled {
			let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: record.metaInfo.timestamp))
			messageHeaderComponents.append(formattedDate)
		}
		
		if case let .enabled(_, level: isLevelEnabled, _, _) = metaInfoEnabling, isLevelEnabled {
			messageHeaderComponents.append(levelPadding
											? record.metaInfo.level.logDescription.padding(toLength: Level.critical.logDescription.count, withPad: " ", startingAt: 0)
											: record.metaInfo.level.logDescription
			)
		}
		
		if let source = recordDetails?.source, !source.isEmpty {
			messageHeaderComponents.append(source.combine(with: "."))
		}

		if let tags = recordDetails?.tags, !tags.isEmpty {
			messageHeaderComponents.append("[\(tags.sorted(by: <).joined(separator: ", "))]")
		}
		
		let messageHeader = messageHeaderComponents.combine(with: componentsSeparator)
		
		var messageComponents = [String]()
		
		messageComponents.append(messageHeader)
		messageComponents.append(record.message)
		
		let finalMessage = messageComponents.combine(with: "\n") + "\n"
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
	public func detailsEnabling (_ detailsEnabling: InputDetails.Enabling) -> Self {
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



public extension AnyPlainConverter {
	static var multilineConverter: AnyPlainConverter<MultilineConverter.InputMessage, MultilineConverter.InputDetails, MultilineConverter.OutputMessage> {
		MultilineConverter().eraseToAnyPlainConverter()
	}
}

public extension Publisher {
	func multiline () -> Publishers.Map<Self, ExportRecord<String>>
	where
	Output == Record<String, CompactRecordDetails>,
	Failure == Never
	{
		convert(.multilineConverter)
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
