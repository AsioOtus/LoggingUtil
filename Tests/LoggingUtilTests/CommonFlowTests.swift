import XCTest
@testable import LoggingUtil
import Combine

final class CommonFlowTests: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    
	func test () {
        let handler = StandardHandler<String, CompactDetails>()
        handler
            .switch { s in
                s.case("") {
                    $0
                        .convert(.singleLineConverter)
                        .printExport()
                }
                s.case("") {
                    $0
                        .convert(.emptyStringConverter)
                        .printExport()
                }
                s.default {
                    $0
                        .convert(.singleLineConverter)
                        .printExport()
                }
                s.unknown {
                    $0
                        .convert(.singleLineConverter)
                        .printExport()
                }
            }
        
        let logger = StandardLogger<String, CompactRecordDetails>()
        logger
            .addConfiguration(.init([.switch: "qwe"]))
            .switch { s in
                s.case("") {
                    $0
                        .convert(.singleLineConverter)
                        .export(to: .printExporter)
//                        .store(in: &subscriptions)
//                        .printExport()
                }
                s.case("") {
                    $0
                        .convert(.emptyStringConverter)
                        .export(to: .printExporter)
//                        .store(in: &subscriptions)
//                        .printExport()
                }
                s.default {
                    $0
                        .convert(.singleLineConverter)
                        .export(to: .printExporter)
//                        .store(in: &subscriptions)
//                        .printExport()
                }
                s.unknown {
                    $0
                        .convert(.singleLineConverter)
                        .export(to: .printExporter)
//                        .store(in: &subscriptions)
//                        .printExport()
                }
            }
        
        logger.info("kek")
	}
	
	func test2 () {
		let l = StandardLogger<String, EmptyRecordDetails>()
		
		l
		.sink { print ($0) }
		.store(in: &subscriptions)
		
		l.info("test")
	}
    
	@available(macOS 12.0, *)
	func test3 () {
        let handler: StandardHandler<String, EmptyDetails> = {
            let handler = StandardHandler<String, EmptyDetails>()
            handler
                .convert(.messageOnlyConverter)
                .printExport()
            return handler
        }()
        
        let logger = StandardLogger<String, EmptyDetails>()
        logger
            .log(to: handler)
            .store(in: &subscriptions)
	}
}
