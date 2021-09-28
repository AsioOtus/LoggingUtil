import XCTest
import Combine
@testable import LoggingUtil

final class LoggingUtilTests: XCTestCase {
	func testBasic () {
		let handler = StandardHandler(
			connector: PlainConnector(
				converter: SingleLineConverter(),
				exporter: PrintExporter()
			)
		)
		
		let logger = StandardLogger(handler: handler)
		logger.trace("Test")
	}
	
	func testClosureConnector () {
		let handler = ClosureHandler<String, StandardLogRecordDetails> { logRecord in
			PlainConnector(
				converter: SingleLineConverter(),
				exporter: PrintExporter()
			)
			.log(logRecord)
			
			ErrorSuppressingConnector(
				converter: StringToJSONDataConverter(),
				exporter: StandardRemoteExporter(url: URL(string: "qweqwe")!)
			)
			.log(logRecord)
		}
		
		let logger = StandardLogger(handler: handler)
		logger.trace("Test")
	}
	
	@available(macOS 12, *)
	func testMultiplex () {
		let handler = MultipleConnectorsHandler()
			.connector(
				PlainConnector(
					converter: SingleLineConverter(),
					exporter: OSLogExporter()
				)
			)
		
		let logger = StandardLogger(handler: handler)
		logger.trace("Test")
	}
	
	@available(macOS 12, *)
	func testSingleLineTags () {
		let handler = MultipleConnectorsHandler()
			.connector(
				PlainConnector(
					converter: SingleLineConverter()
						.detailsEnabling(.enabled(tags: true)),
					exporter: OSLogExporter()
				)
			)
		
		let logger = StandardLogger(handler: handler)
		logger.trace("Test", details: .init(tags: ["qwe"]))
	}
}
