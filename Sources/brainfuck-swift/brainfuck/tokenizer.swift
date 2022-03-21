/// Converts the raw source code into tokens
public struct Tokenizer {
    /// Convert Brainfuck source code to tokens
    public static func tokenize(source: String) -> Tokens {
        var tokens = Tokens()
        var row = 0
        var subFromIdxToCols = 0
        source.enumerated().forEach { (idx: Int, char: Character) in
            let col = idx - subFromIdxToCols
            let token: Token = {
                switch char {
                    case "+":
                        return .Increment(Position(row: row, col: col))
                    case "-":
                        return .Decrement(Position(row: row, col: col))
                    case "<":
                        return .Left(Position(row: row, col: col))
                    case ">":
                        return .Right(Position(row: row, col: col))
                    case ".":
                        return .Output(Position(row: row, col: col))
                    case ",":
                        return .Input(Position(row: row, col: col))
                    case "[":
                        return .StartLoop(Position(row: row, col: col))
                    case "]":
                        return .EndLoop(Position(row: row, col: col))
                    case "\n":
                        row += 1
                        subFromIdxToCols += idx + 1
                        return .Ignore
                    default: 
                        return .Ignore
                }
            }()
            tokens.append(token)
        }
        return tokens
    }
}

/// The position of an element in the source code
public struct Position {
    public let row: Int
    public let col: Int
}

extension Position: Equatable {}

/// A character in the brainfuck source code
public enum Token {
    /// `+`
    case Increment(Position)
    /// `-`
    case Decrement(Position)
    /// `<`
    case Left(Position)
    /// `>`
    case Right(Position)
    /// `.`
    case Output(Position)
    /// `,`
    case Input(Position)
    /// `[`
    case StartLoop(Position)
    /// `]`
    case EndLoop(Position)
    /// Any other character
    case Ignore
}

extension Token: Equatable {}

/// A ``Token`` sequence
public struct Tokens {
    private var tokens: [Token]
    // private var tokens: IndexingIterator<[Token]>

    /// Creates a new token sequence with the specified Tokens
    public init(tokens: [Token] = []) {
        self.tokens = tokens
    }
}

extension Tokens: Sequence {
    public typealias Iterator = IndexingIterator<[Token]>

    public func makeIterator() -> Iterator {
        self.tokens.makeIterator()
    }
}

extension Tokens: RangeReplaceableCollection {
    public init() {
        self.tokens = []
    }

    public mutating func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C : Collection, Token == C.Element {
        self.tokens.replaceSubrange(subrange, with: newElements)
    }
}

extension Tokens: Collection {
    public typealias Index = Int
    public typealias Element = Token
    
    public var startIndex: Index {
        self.tokens.startIndex
    }

    public var endIndex: Index {
        self.tokens.endIndex
    }

    public subscript(position: Index) -> Element {
        // precondition(position >= self.tokens.count, "out of bounds")
        return self.tokens[position]
    }

    public func index(after i: Index) -> Index {
        return self.tokens.index(after: i)
    }
}

extension Tokens: Equatable {}
