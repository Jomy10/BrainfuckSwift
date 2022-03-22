/// Input stream for `,` operator
public protocol InputStream {
    var buffer: String { get set }
    mutating func requestNextChar() throws -> UInt8
    mutating func readMore()
    func hasMoreStored() -> Bool
    func bufferIsEmpty() -> Bool
}

/// Standard input stream
public struct StdInStream: InputStream {
    public var buffer: String = ""

    public init() {}
    public init(_ buffer: String) { self.buffer = buffer }

    public mutating func requestNextChar() throws -> UInt8 {
        if buffer.isEmpty {
            self.readMore()
        }
        if let i = self.buffer.utf8.first {
            self.buffer.removeFirst()
            return i
        } else {
            throw InputError(localizedDescription: "Could not encode input to 256 bit")
        }
    }
    public mutating func readMore() {
        self.buffer.append(readLine()!)
    }

    public func hasMoreStored() -> Bool {
        !self.buffer.isEmpty
    }

    public func bufferIsEmpty() -> Bool {
        self.buffer.isEmpty
    }
}

public struct InputError: Error {
    var localizedDescription: String
}

public struct StringInputStream: InputStream {
    public var buffer: String = ""
    private var iter: String.Iterator

    init(_ s: String) {
        self.buffer = s
        self.iter = self.buffer.makeIterator()
    }

    public mutating func requestNextChar() throws -> UInt8 {
        return self.iter.next()!.utf8.first!
    }

    public mutating func readMore() {
        fatalError("StringInputStreams cannot read more")
    }

    public func hasMoreStored() -> Bool {
        true
    }

    public func bufferIsEmpty() -> Bool {
        false
    }
}