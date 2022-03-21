// print(“\(#file):\(#function):\(#line) — Hey!”)

/// Executes the brainfuck ``Tree``
class Interpreter<OutputStreamType: TextOutputStream, ErrStreamType: TextOutputStream, InputStreamType: InputStream> {
    private var nodes: Tree
    private var ptr: Int = 0
    private var arr = [UInt8](repeating: 0, count: 30_000)
    /// The greatest integer that can be stored in a cell
    private let maxCell = UInt8(2^^8 - 1)
    /// The position in the source code
    private var codePos = Position(row: -1, col: -1)
    private let options: InterpretOptions

    private var inStream: InputStreamType?

    public init(tree: Tree, options: InterpretOptions = InterpretOptions(options: [])) {
        self.nodes = tree
        self.options = options
    }
}

extension Interpreter {
    /// Start interpreting the nodes
    public func exec(outputStream: inout OutputStreamType, errorStream: inout ErrStreamType, inputStream: InputStreamType) {
        self.inStream = inputStream
        var iter = nodes.makeIterator()
        execTree(&iter, out: &outputStream, err: &errorStream)
    }

    private func execTree(_ iter: inout Tree.Iterator, out: inout OutputStreamType, err: inout ErrStreamType) {
        while let node = iter.next() {
            switch node {
                case .Increment(pos: let pos):
                    // print("increment", self.arr[self.ptr])
                    self.codePos = pos
                    self.execIncrement()
                case .Decrement(pos: let pos):
                    self.codePos = pos
                    self.execDecrement()
                case .Left(pos: let pos):
                    self.codePos = pos
                    self.execLeft()
                case .Right(pos: let pos):
                    self.codePos = pos
                    self.execRight()
                case .Output(pos: let pos):
                    self.codePos = pos
                    self.execOutput(&out)
                case .Input(pos: let pos):
                    self.codePos = pos
                    self.execInput(out: &out, err: &err)
                case .Loop(startPos: let startPos, let tree):
                    self.codePos = startPos
                    self.execLoop(tree: tree, out: &out, err: &err)
            }
        }
    }

    private func execIncrement() {
        if self.arr[self.ptr] != self.maxCell { 
            self.arr[self.ptr] += 1
        } else {
            self.arr[self.ptr] = 0
        }
    }

    private func execDecrement() {
        if self.arr[self.ptr] != 0 {
            self.arr[self.ptr] -= 1
        } else {
            self.arr[self.ptr] = self.maxCell
        }
    }

    private func execLeft() {
        if self.ptr == 0 {
            self.ptr = 29_999
        } else {
            self.ptr -= 1
        }
    }

    private func execRight() {
        if self.ptr == 29_999 {
            self.ptr = 0
        } else {
            self.ptr += 1
        }
    }

    private func execOutput(_ out: inout OutputStreamType) {
        print(Character(UnicodeScalar(self.arr[self.ptr])), terminator: "", to: &out)
    }

    private func execInput(out: inout OutputStreamType, err: inout ErrStreamType) {
        if self.options.visualInput && self.inStream!.bufferIsEmpty() {
            // Write to new line if there is already something on current line
            if let outStr = out as? FileHandleOutputStream {
                if (outStr.lastPrint.last == "\n" || outStr.lastPrint.last == nil) {
                    print("> ", terminator: "", to: &err) 
                } else {
                    print("\n> ", terminator: "", to: &err)  
                }
            } else {
                print("\n> ", terminator: "", to: &err) 
            }
        }
        do { self.arr[self.ptr] = try self.inStream!.requestNextChar() }
        catch(let err) { if let inputErr = err as? InputError { fatalError(inputErr.localizedDescription) } else { fatalError(err.localizedDescription) } }
    }

    private func execLoop(tree: Tree, out: inout OutputStreamType, err: inout ErrStreamType) {
        while self.arr[self.ptr] != 0 {
            var iter = tree.makeIterator()
            self.execTree(&iter, out: &out, err: &err)
        }
    }
}

public struct InterpretOptions {
    public var options: Set<InterpretOption>

    public var visualInput: Bool {
        get { self.options.contains(.visualInput) }
    }
}

public enum InterpretOption {
    case visualInput
}