import XCTest
@testable import LoggingUtil

final class CommonFlowTests: XCTestCase {
	func testStd () {
		let singleLineConverter = SingleLineConverter(alias: "SingleLine.Converter")
			.metaInfoEnabling(.enabled(timestamp: true))
		
		let printExporter = PrintExporter(alias: "Print.Exporter")
		
		let standardHandler = MultipleConnectorsHandler<String, StandardRecordDetails>(alias: "Standard.Handler")
			.connector(
				.plain(
					CustomConverter(alias: "Custom.Converter") { record in
						record.metaInfo.stack.compactMap{ $0.alias }.joined(separator: " | ")
					},
					printExporter,
					alias: "Plain.Connector"
				)
			)
			.connector(.plain(singleLineConverter, printExporter))
		
		let uiHandler = MultiplexCustomHandler<String, StandardRecordDetails>()
		
		
		let centralHandler = MultiplexHandler<String, StandardRecordDetails>(alias: "Central.Handler")
			.details(.init(source: ["App"]))
			.handler(standardHandler)
			.handler(uiHandler)
		
		let globalLogger = StandardLogger(centralHandler, alias: "Global.Logger")
			.details(.init(source: ["Global"], tags: ["Kek"]))
		
		let moduleLogger = StandardLogger(centralHandler, alias: "Module.Logger")
			.details(.init(source: ["Module"], tags: ["Lol"]))
		
		
		
		globalLogger.info("ABC")
		moduleLogger.notice("qwerty")
	}
}
