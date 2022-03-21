import Foundation

let tokens = Tokenizer.tokenize(source: "+[,.]")
var tokenIter = tokens.makeIterator()
let tree = Tree(tokens: &tokenIter)

var stdout = FileHandleOutputStream(FileHandle.standardOutput, name: "out")
var stdin = StdInStream()
var stderr = FileHandleOutputStream(FileHandle.standardError, name: "err")
Interpreter(tree: tree, options: InterpretOptions(options: [.visualInput])).exec(outputStream: &stdout, errorStream: &stderr, inputStream: stdin)
