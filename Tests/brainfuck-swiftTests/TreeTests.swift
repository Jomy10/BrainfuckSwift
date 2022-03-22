import XCTest
@testable import BrainfuckCore

final class TreeTests: XCTestCase {
    func testTreeGen() {
        let tokens = Tokenizer.tokenize(source: "+>-[<-],[.[>+[<-]-]].")
        var tokensIter = tokens.makeIterator()
        let tree = Tree(tokens: &tokensIter)

        var expectedTree = Tree()
        expectedTree.nodes = [
            .Increment(pos: Position(row: 0, col: 0)),
            .Right(pos: Position(row: 0, col: 1)),
            .Decrement(pos: Position(row: 0, col: 2)),
            .Loop(startPos: Position(row: 0, col: 3), Tree(nodes: [
                .Left(pos: Position(row: 0, col: 4)),
                .Decrement(pos: Position(row: 0, col: 5)),
            ])),
            .Input(pos: Position(row: 0, col: 7)),
            .Loop(startPos: Position(row: 0, col: 8), Tree(nodes: [
                .Output(pos: Position(row: 0, col: 9)),
                .Loop(startPos: Position(row: 0, col: 10), Tree(nodes: [
                    .Right(pos: Position(row: 0, col: 11)),
                    .Increment(pos: Position(row: 0, col: 12)),
                    .Loop(startPos: Position(row: 0, col: 13), Tree(nodes: [
                        .Left(pos: Position(row: 0, col: 14)),
                        .Decrement(pos: Position(row: 0, col: 15)),
                    ])),
                    .Decrement(pos: Position(row: 0, col: 17))
                ]))
            ])),
            .Output(pos: Position(row: 0, col: 20)),
        ]

        XCTAssertEqual(expectedTree, tree)
    }

    func testTreeGenWithCommentsAndNewLines() {
        let tokens = Tokenizer.tokenize(source: "+>-[<-],H[.[>+\n[<-]-]].")
        var tokensIter = tokens.makeIterator()
        let tree = Tree(tokens: &tokensIter)

        var expectedTree = Tree()
        expectedTree.nodes = [
            .Increment(pos: Position(row: 0, col: 0)),
            .Right(pos: Position(row: 0, col: 1)),
            .Decrement(pos: Position(row: 0, col: 2)),
            .Loop(startPos: Position(row: 0, col: 3), Tree(nodes: [
                .Left(pos: Position(row: 0, col: 4)),
                .Decrement(pos: Position(row: 0, col: 5)),
            ])),
            .Input(pos: Position(row: 0, col: 7)),
            .Loop(startPos: Position(row: 0, col: 9), Tree(nodes: [
                .Output(pos: Position(row: 0, col: 10)),
                .Loop(startPos: Position(row: 0, col: 11), Tree(nodes: [
                    .Right(pos: Position(row: 0, col: 12)),
                    .Increment(pos: Position(row: 0, col: 13)),
                    .Loop(startPos: Position(row: 1, col: 0), Tree(nodes: [
                        .Left(pos: Position(row: 1, col: 1)),
                        .Decrement(pos: Position(row: 1, col: 2)),
                    ])),
                    .Decrement(pos: Position(row: 1, col: 4))
                ]))
            ])),
            .Output(pos: Position(row: 1, col: 7)),
        ]

        XCTAssertEqual(expectedTree, tree)
    }
}
