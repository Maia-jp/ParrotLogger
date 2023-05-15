//
//  ParrotLoggerExportTests.swift
//  
//
//  Created by Victor Letichevsky on 15/05/23.
//

import XCTest
@testable import ParrotLogger

final class ParrotLoggerExportTests: XCTestCase {
    static let logs: [ParrotLogger.LogEntry] = [
        ParrotLogger.LogEntry(date: Date(), logLevel: .info, category: "Category 1", functionName: "Function 1", content: "Log message 1"),
        ParrotLogger.LogEntry(date: Date(), logLevel: .warning, category: "Category 2", functionName: "Function 2", content: "Log message 2"),
        ParrotLogger.LogEntry(date: Date(), logLevel: .error, category: "Category3", functionName: "Function3", content: "Log entry 3")
    ]
    
    func testSaveLogToTxt() {
        
        let logs = ParrotLoggerExportTests.logs
        
        let url = ParrotLogger.saveLogToTxt(logs, appName: "MyApp")
        XCTAssertNotNil(url, "Failed to save log entries to file")
        
        guard let url else { return }
        
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: url.path))
        
        do {
            let fileContents = try String(contentsOf: url, encoding: .utf8)
            
            let logStrings = logs.map { logEntry -> String in
                
                let date = ParrotLogger.formatDate(logEntry.date)
                let logLevel = ParrotLogger.escapeValue(logEntry.logLevel.rawValue)
                let category = ParrotLogger.escapeValue(logEntry.category)
                let functionName = ParrotLogger.escapeValue(logEntry.functionName)
                let content = ParrotLogger.escapeValue(logEntry.content)
                
                return "\(date) - \(logLevel) - \(category) - \(functionName) - \(content)\n"
            }
            
            let expectedFileContents = logStrings.joined(separator: "\n")
            
            XCTAssertEqual(fileContents, expectedFileContents, "File contents should match the expected log entries")
        } catch {
            XCTFail("Failed to read file contents: \(error.localizedDescription)")
        }
        
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            XCTFail("Failed to remove file: \(error.localizedDescription)")
        }
    }
    
    func testSaveLogToCSV() {
        let logs = ParrotLoggerExportTests.logs
        
        let url = ParrotLogger.saveLogToCSV(logs, appName: "MyApp")
        XCTAssertNotNil(url, "Failed to save log entries to file")
        
        guard let url else { return }
        
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: url.path))
        
        do {
            let csvContent = try String(contentsOf: url, encoding: .utf8)
            let trimmedCSVContent = csvContent.trimmingCharacters(in: .whitespacesAndNewlines)
            let expectedCSVContent = """
                    Date,LogLevel,Category,FunctionName,Content
                    \(ParrotLogger.formatDate(logs[0].date)),\(logs[0].logLevel.rawValue),\(logs[0].category),\(logs[0].functionName),\(logs[0].content)
                    \(ParrotLogger.formatDate(logs[1].date)),\(logs[1].logLevel.rawValue),\(logs[1].category),\(logs[1].functionName),\(logs[1].content)
                    \(ParrotLogger.formatDate(logs[2].date)),\(logs[2].logLevel.rawValue),\(logs[2].category),\(logs[2].functionName),\(logs[2].content)
                    """
            
            XCTAssertEqual(trimmedCSVContent, expectedCSVContent)
        } catch {
            XCTFail(": \(error.localizedDescription)")
        }
    }
    
    func testSaveLogToXML() {
        let logs = ParrotLoggerExportTests.logs

        let url = ParrotLogger.saveLogToXML(logs, appName: "MyApp")
        XCTAssertNotNil(url, "Failed to save log entries to file")
        
        guard let url else { return }
                
        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: url.path))
        
        do {
            let xmlContent = try String(contentsOf: url, encoding: .utf8)
            let expectedXMLContent = """
                   <?xml version="1.0" encoding="UTF-8"?>
                   <logs>
                   <log>
                   <date>\(ParrotLogger.formatDate(logs[0].date))</date>
                   <logLevel>\(logs[0].logLevel.rawValue)</logLevel>
                   <category>\(logs[0].category)</category>
                   <functionName>\(logs[0].functionName)</functionName>
                   <content>\(logs[0].content)</content>
                   </log>
                   <log>
                   <date>\(ParrotLogger.formatDate(logs[1].date))</date>
                   <logLevel>\(logs[1].logLevel.rawValue)</logLevel>
                   <category>\(logs[1].category)</category>
                   <functionName>\(logs[1].functionName)</functionName>
                   <content>\(logs[1].content)</content>
                   </log>
                   <log>
                   <date>\(ParrotLogger.formatDate(logs[2].date))</date>
                   <logLevel>\(logs[2].logLevel.rawValue)</logLevel>
                   <category>\(logs[2].category)</category>
                   <functionName>\(logs[2].functionName)</functionName>
                   <content>\(logs[2].content)</content>
                   </log>
                   </logs>
                   """
            let cleanedXMLContent = xmlContent.replacingOccurrences(of: #"[\t\n\s]+"#, with: "", options: .regularExpression)
            let cleanedXMLExpectedContent = expectedXMLContent.replacingOccurrences(of: #"[\t\n\s]+"#, with: "", options: .regularExpression)

            XCTAssertEqual(cleanedXMLContent, cleanedXMLExpectedContent)
        } catch {
            XCTFail("Error reading XML file: \(error.localizedDescription)")
        }
    }
    
    func testSaveLogToJSON() {
        let logs = ParrotLoggerExportTests.logs

        let url = ParrotLogger.saveLogToJSON(logs, appName: "MyApp")
        XCTAssertNotNil(url, "Failed to save log entries to file")
        
        guard let url else { return }

        let fileManager = FileManager.default
        XCTAssertTrue(fileManager.fileExists(atPath: url.path))

        do {
            let jsonData = try Data(contentsOf: url)
            let decodedLogs = try JSONDecoder().decode([ParrotLogger.LogEntry].self, from: jsonData)
            XCTAssertEqual(decodedLogs, logs)
        } catch {
            XCTFail("Error reading or decoding JSON file: \(error.localizedDescription)")
        }
    }
    
    func testSaveLogEntries() {
        let logs = ParrotLoggerExportTests.logs
        
        for fileType in ParrotLogger.LogFileType.allCases {
            let url = ParrotLogger.saveLogEntries(logs, to: fileType, withAppName: "MyApp")
            XCTAssertNotNil(url, "Failed to save log entries to file")
            guard let url else { return }
            XCTAssert(FileManager.default.fileExists(atPath: url.path), "Log saved as CSV")
        }
    }
}
