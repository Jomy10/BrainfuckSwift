// I guess it's not technically a tree, but I don't know what to call this

/// Structure containing all the brainfuck ``Node``s
public struct Tree {
    public var nodes: [Node]

    /// Create a new tree from a ``Token`` sequence.
    /// The function takes in the tokens as mutable
    public init(tokens: inout Tokens.Iterator) {
        self.nodes = []
        while let token = tokens.next() {
            switch token {
                case .Increment(let pos):
                    nodes.append(.Increment(pos: pos))
                case .Decrement(let pos):
                    nodes.append(.Decrement(pos: pos))
                case .Left(let pos):
                    nodes.append(.Left(pos: pos))
                case .Right(let pos):
                    nodes.append(.Right(pos: pos))
                case .Output(let pos):
                    nodes.append(.Output(pos: pos))
                case .Input(let pos):
                    nodes.append(.Input(pos: pos))
                case .StartLoop(let pos):
                    nodes.append(.Loop(startPos: pos, Tree(tokens: &tokens)))
                case .EndLoop(_):
                    return
                default:
                    break
            }
        }
    }

    // Create an empty tree
    public init(nodes: [Node] = []) {
        self.nodes = nodes
    }
}

extension Tree: Equatable {}

extension Tree: Sequence {
    public typealias Iterator = IndexingIterator<[Node]>

    public func makeIterator() -> Iterator {
        self.nodes.makeIterator()
    }
}

/// A node containing all necessary information about a brainfuck operator
public enum Node {
    case Increment(pos: Position)
    case Decrement(pos: Position)
    case Left(pos: Position)
    case Right(pos: Position)
    case Output(pos: Position)
    case Input(pos: Position)
    case Loop(startPos: Position, Tree)
}

extension Node: Equatable {}
