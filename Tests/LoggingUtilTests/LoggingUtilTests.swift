import XCTest
import Combine
@testable import LoggingUtil

final class LoggingUtilTests: XCTestCase {
	func testBasic () {
		let handler = StandardHandler(
			PlainConnector(
				converter: SingleLineConverter(),
				exporter: PrintExporter()
			)
		)
		
		let logger = StandardLogger(handler)
		logger.trace("Test")
	}
	
	func testClosureConnector () {
		let handler = CustomHandler<String, StandardRecordDetails> { record in
			PlainConnector(
				converter: SingleLineConverter(),
				exporter: PrintExporter()
			)
			.log(record)
			
			ErrorSuppressingConnector(
				converter: StringToJSONDataConverter(),
				exporter: StandardRemoteExporter(url: URL(string: "qweqwe")!)
			)
			.log(record)
		}
		
		let logger = StandardLogger(handler)
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
		
		let logger = StandardLogger(handler)
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
		
		let logger = StandardLogger(handler)
		logger.trace("Test", details: .init(tags: ["qwe"]))
	}
}
