import XCTest
import Foundation
@testable import brainfuck_swift

final class InterpreterTests: XCTestCase {
    func testCat() throws {
        var catDir = FileManager.default.currentDirectoryPath
        catDir.append(contentsOf: "/Examples/cat.bf")
        let tokens = Tokenizer.tokenize(source: try NSString(contentsOfFile: catDir, encoding: String.Encoding.utf8.rawValue) as String)
        var tokenIter = tokens.makeIterator()
        let tree = Tree(tokens: &tokenIter)

        var stdout = ""
        let stdin = StringInputStream("Hello Cat!\u{00}")
        var stderr = FileHandleOutputStream(FileHandle.standardError, name: "err")
        Interpreter(tree: tree, options: InterpretOptions(options: [])).exec(outputStream: &stdout, errorStream: &stderr, inputStream: stdin)

        XCTAssertEqual("Hello Cat!\u{00}", stdout)
    } 
}