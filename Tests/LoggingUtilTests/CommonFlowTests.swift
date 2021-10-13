import XCTest
@testable import LoggingUtil

final class CommonFlowTests: XCTestCase {
	func testStd () {		
		let defaultExporter = PrintExporter(label: "Exporter.Default")
		
		let centralHandler = SwitchHandler(label: "Handler.Central")
			.handler(
				key: "UserDefaultsUtil",
				PlainConnector(
					converter: SingleLineConverter(label: "Converter.SingleLine")
						.detailsEnabling(.enabled(tags: false))
						.metaInfoEnabling(.enabled(level: false)),
					exporter: defaultExporter
				)
			)
			.handler(
				key: "BaseNetworkUtil",
				StandardHandler {
					PlainConnector(MultilineConverter())
						.exporter(defaultExporter)
						.isEnabled(false)
						.eraseToAnyHandler()
					
					PlainConnector(SingleLineConverter())
						.exporter(defaultExporter)
						.eraseToAnyHandler()
				}
			)
			.defaultHandler(
				PlainConnector(MultilineConverter(label: "Converter.Multiline"))
					.exporter(defaultExporter)
			)
	}
}
