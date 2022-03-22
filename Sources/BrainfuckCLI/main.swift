import Foundation
import BrainfuckCore

var bfPath = FileManager.default.currentDirectoryPath
bfPath.append("/Examples/hello_world.bf")
let tokens = Tokenizer.tokenize(source: try NSString(contentsOfFile: bfPath, encoding: String.Encoding.utf8.rawValue) as String)
var tokenIter = tokens.makeIterator()
let tree = Tree(tokens: &tokenIter)

var stdout = FileHandleOutputStream(FileHandle.standardOutput, name: "out")
var stdin = StdInStream()
var stderr = FileHandleOutputStream(FileHandle.standardError, name: "err")
Interpreter(tree: tree, options: InterpretOptions(options: [.visualInput])).exec(outputStream: &stdout, errorStream: &stderr, inputStream: stdin)
