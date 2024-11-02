import XCTest
@testable import ParrotLogger

final class ParrotLoggerTests: XCTestCase {
    
    func testSimple() {
        func sumOperation(a: Int, b: Int) {
            let logger = ParrotLogger(category: "CATEGORY")
            logger.warning("default description mode")
            let loggerF = ParrotLogger(category: "CATEGORY", functionDescriptionMode: .full)
            loggerF.warning("full description mode")
            let loggerN = ParrotLogger(category: "CATEGORY", functionDescriptionMode: .nameOnly)
            loggerN.warning("nameOnly description mode")
            let loggerO = ParrotLogger(category: "CATEGORY", functionDescriptionMode: .omitted)
            loggerO.warning("omitted description mode")
        }
        sumOperation(a: 1, b: 1)
//        let logger = ParrotLogger(category: "new")
//        logger(\.critical, "testing")
//        logger(\.error, 1, 2, 3, 4)
//        logger[\.trace]("warning")
//        logger[\.nice]("nice message")
//        logger[\.navigation]("Calendar")
        let pl1 = ParrotLogger(logLevelName: "teste 🐶", category: "a", functionDescriptionMode: .omitted)
        
        pl1.info("testando")
        let text = "abc"
        print("\(String(repeating: "0", count: max(0, 10 - text.count)))\(text)")
        print(1, 2)
    }
}

//extension LogSeverity2 {
//    var nice: Key { Key(named: "Nice", marker: "/", moreSevereThan: \.debug) }
//    var navigation: Key { Key(named: "Navigation", marker: "🗺️", moreSevereThan: \.debug) }
//}
