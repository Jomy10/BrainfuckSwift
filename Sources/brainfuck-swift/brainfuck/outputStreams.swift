import class Foundation.FileHandle

public struct FileHandleOutputStream: TextOutputStream {
    private let fileHandle: FileHandle
    private let encoding: String.Encoding
    public var lastPrint: String = ""
    private let outputName: String

    public init(_ fileHandle: FileHandle, encoding: String.Encoding = .utf8, name: String = "") {
        self.fileHandle = fileHandle
        self.encoding = encoding
        self.outputName = name
    }

    public mutating func write(_ string: String) {
        if string != "" { self.lastPrint = string }
        if let data = string.data(using: self.encoding) {
            self.fileHandle.write(data)
        }
    }
}
