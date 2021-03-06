//
//  Run the brainfuck interpreter on a string of a source file
//  Platform independent
//  
//  (c) 2022 Jonas Everaert
//  

import Foundation
import BrainfuckCore
@_exported import struct BrainfuckCore.InterpretOptions
@_exported import enum BrainfuckCore.InterpretOption
@_exported import protocol BrainfuckCore.InputStream
@_exported import struct BrainfuckCore.FileHandleOutputStream
@_exported import struct BrainfuckCore.StdInStream
@_exported import struct BrainfuckCore.StringInputStream

/// Run the brainfuck interpreter for the ``source`` code with the given ``options``
public func run<OutputStreamType: TextOutputStream, ErrStreamType: TextOutputStream, InputStreamType: BrainfuckCore.InputStream>(
    source: String, 
    options: InterpretOptions, 
    outStream out: inout OutputStreamType,
    errStream err: inout ErrStreamType,
    inStream ins: InputStreamType
) {
    let tokens = Tokenizer.tokenize(source: source)
    var tokenIter = tokens.makeIterator()
    let tree = Tree(tokens: &tokenIter)

    Interpreter(tree: tree, options: options).exec(outputStream: &out, errorStream: &err, inputStream: ins)
}
