// print(“\(#file):\(#function):\(#line) — Hey!”)

/// Executes the brainfuck ``Tree``
public class Interpreter<OutputStreamType: TextOutputStream, ErrStreamType: TextOutputStream, InputStreamType: InputStream> {
    private var nodes: Tree
    private var ptr: Int = 0
    private var arr: [UInt8]
    /// The greatest integer that can be stored in a cell
    private let maxCell = UInt8(2^^8 - 1)
    /// The position in the source code
    private var codePos = Position(row: -1, col: -1)
    private let options: InterpretOptions

    private var inStream: InputStreamType?

    public init(tree: Tree, options: InterpretOptions = InterpretOptions(options: [])) {
        self.nodes = tree
        self.options = options
        self.arr = [UInt8](repeating: 0, count: self.options.arraySize)
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

    public init(options: Set<InterpretOption>) {
        self.options = options
    }
    /// Shows a '>' when asking for input
    public var visualInput: Bool {
        get { self.options.contains(.visualInput) }
    }
    /// Set the size of the array (default: 30000)
    public var arraySize: Int {
        get {
            var size = 30_000
            _ = self.options.first(where: { 
                if case let .arraySize(size: val) = $0 {
                    size = val
                    return true
                } else {
                    return false
                }
            }) 
            return size
        }
    }
    /// Show the array while the program is executing
    public var visualArray: Bool { 
        get { self.options.contains(.visualArray) }
    }
    /// Show where the program is in the source code
    public var visualExecution: Bool {
        get { self.options.contains(.visualExecution) }
    }
    /// Leave the previous array and/or line in the program (if set with --visual-array and --visual-execution) instead of overwriting
    public var visualDebugDontErase: Bool {
        get { self.options.contains(.visualDebugDontErase) }
    }
    // TODO
}

public enum InterpretOption: Hashable {
    /// Shows a '>' when asking for input
    case visualInput
    /// Set the size of the array (default: 30000)
    case arraySize(size: Int)
    /// Show the array while the program is executing
    case visualArray
    /// Show where the program is in the source code
    case visualExecution
    /// Leave the previous array and/or line in the program (if set with --visual-array and --visual-execution) instead of overwriting
    case visualDebugDontErase
    /// Execute the program step by step. Only continue to the next command when return is pressed
    case stepDebug
    /// Sets the amount of bits that can be stored in a cell (default: 8)
    case cellSize(size: Int)
    /// Don't execute code after ';;', or after custom comment syntax
    case comments(syntax: String)
    /// Shows cells as numbers in output instead of text
    case numberMode
}
