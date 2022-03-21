import Foundation

let tokens = Tokenizer.tokenize(source: ">++++++++[<+++++++++>-]<. ;; perform loop 8 times; each time adding 9 to the previous cell_ print out that cell (which is now 72 = H)>++++[<+++++++>-]<+.  ;; 101 = e (4 * 7 = 28; ^ 1 = 29 ;; 72 ^ 29)")
var tokenIter = tokens.makeIterator()
let tree = Tree(tokens: &tokenIter)

var stdout = FileHandleOutputStream(FileHandle.standardOutput, name: "out")
var stdin = StdInStream()
var stderr = FileHandleOutputStream(FileHandle.standardError, name: "err")
Interpreter(tree: tree, options: InterpretOptions(options: [.visualInput])).exec(outputStream: &stdout, errorStream: &stderr, inputStream: stdin)
