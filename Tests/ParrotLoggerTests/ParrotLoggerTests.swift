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
        let logger = ParrotLogger(category: "new")
        logger(\.critical, "testing")
        logger(\.error, 1, 2, 3, 4)
        logger[\.trace]("warning")
        logger[\.nice]("nice message")
        print(1, 2)
    }
}

extension LogSeverityKeys {
    var nice: LogSeverityKey { .init("Nice", ":D", moreSevereThan: \.debug) }
}
