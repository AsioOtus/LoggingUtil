import XCTest
@testable import LoggingUtil

final class CommonFlowTests: XCTestCase {
	func testStd () {		
		let printExporter = PrintExporter(label: "Print.Exporter")
		
		let standardHandler = MultipleConnectorsHandler<String, StandardRecordDetails>(label: "Standard.Handler")
			.connector(
				.plain(
					CustomConverter(label: "Custom.Converter") { record in
						record.metaInfo.stack.compactMap{ $0.label }.joined(separator: " | ")
					},
					printExporter,
					label: "Plain.Connector"
				)
			)
			.connector(
				.plain(
					SingleLineConverter(label: "SingleLine.Converter")
						.metaInfoEnabling(.enabled(timestamp: true)),
					printExporter
				)
			)
		
		let uiHandler = MultiplexCustomHandler<String, StandardRecordDetails>()
		
		
		let centralHandler = MultiplexHandler<String, StandardRecordDetails>(label: "Central.Handler")
			.details(.init(source: ["App"]))
			.handler(standardHandler)
			.handler(uiHandler)
		
		let globalLogger = StandardLogger(centralHandler, label: "Global.Logger")
			.details(.init(source: ["Global"], tags: ["Kek"]))
		
		let moduleLogger = StandardLogger(centralHandler, label: "Module.Logger")
			.details(.init(source: ["Module"], tags: ["Lol"]))
		
		
		
		globalLogger.info("ABC")
		moduleLogger.notice("qwerty")
	}
}
