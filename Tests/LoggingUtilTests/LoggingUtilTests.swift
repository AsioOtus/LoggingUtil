import XCTest
import Combine
@testable import LoggingUtil

final class LoggingUtilTests: XCTestCase {
	func testBasic () {
		let logHandler = StandardLogHandler(
			connector: PlainConnector(
				converter: SingleLineConverter(),
				exporter: PrintExporter()
			)
		)
		
		let logger = StandardLogger(logHandler: logHandler)
		logger.trace("Test")
	}
	
	func testClosureConnector () {
		let logHandler = ClosureLogHandler<String, StandardLogRecordDetails> { logRecord in
			PlainConnector(
				converter: SingleLineConverter(),
				exporter: PrintExporter()
			)
			.log(logRecord)
			
			ErrorSuppressingConnector(
				converter: StringToJSONDataConverter(),
				exporter: StandardRemoteLogExporter(url: URL(string: "qweqwe")!)
			)
			.log(logRecord)
		}
		
		let logger = StandardLogger(logHandler: logHandler)
		logger.trace("Test")
	}
	
	@available(macOS 12, *)
	func testMultiplex () {
		let logHandler = MultiplexLogHandler()
			.connector(
				PlainConnector(
					converter: SingleLineConverter(),
					exporter: OSLogExporter()
				)
			)
		
		let logger = StandardLogger(logHandler: logHandler)
		logger.trace("Test")
	}
}
