import XCTest
@testable import LoggingUtil
import Combine

final class CommonFlowTests: XCTestCase {
    var storage = Set<AnyCancellable>()
    
//	func test () {
//        let handler = PassthroughSubject<LoggingUtil.Record<String, CompactRecordDetails>, Never>()
//        let configured = handler.addDetails(.init())
//        
//        configured
//            .switch { s in
//                s.case("") {
//                    $0
//                        .convert(.singleLineConverter)
//                        .printExport()
//
//                }
//                s.case("") {
//                    $0
//                        .map { _ in (MetaInfo.empty, "") }
//                        .printExport()
//                }
//                s.default {
//                    $0
//                        .convert(.singleLineConverter)
//                        .printExport()
//                }
//            }
//        
//        let logger = StandardLogger<String, CompactRecordDetails>()
//        logger
//            .bind(to: handler)
//            .store(in: &storage)
//        
//        logger.info("test")
//	}
	
	func test2 () {
		let l = StandardLogger<String, EmptyRecordDetails>()
		
		l
		.sink { print ($0) }
		.store(in: &storage)
		
		l.info("test")
	}
	
	func test3 () {
		let logger = StandardLogger<String, EmptyRecordDetails>()
		logger
			.convert(.messageOnlyConverter)
			.printExport()
	}
}
