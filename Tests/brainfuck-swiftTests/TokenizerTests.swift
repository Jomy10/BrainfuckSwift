import XCTest
@testable import BrainfuckCore

final class TokenizerTests: XCTestCase {
    func testTokenizer() {
        let tokens = Tokenizer.tokenize(source: "><[+]-,H.")

        let expectedTokens = Tokens(tokens: [
            .Right(Position(row: 0, col: 0)),
            .Left(Position(row: 0, col: 1)),
            .StartLoop(Position(row: 0, col: 2)),
            .Increment(Position(row: 0, col: 3)),
            .EndLoop(Position(row: 0, col: 4)),
            .Decrement(Position(row: 0, col: 5)),
            .Input(Position(row: 0, col: 6)),
            .Ignore,
            .Output(Position(row: 0, col: 8))
        ])

        XCTAssertEqual(expectedTokens, tokens)
    }

    func testTokenizerNewLines() {
        let tokens = Tokenizer.tokenize(source: ">+[>-<]\nCo++")

        let expectedTokens = Tokens(tokens: [
            .Right(Position(row: 0, col: 0)),
            .Increment(Position(row: 0, col: 1)),
            .StartLoop(Position(row: 0, col: 2)),
            .Right(Position(row: 0, col: 3)),
            .Decrement(Position(row: 0, col: 4)),
            .Left(Position(row: 0, col: 5)),
            .EndLoop(Position(row: 0, col: 6)),
            .Ignore,
            .Ignore,
            .Ignore,
            .Increment(Position(row: 1, col: 2)),
            .Increment(Position(row: 1, col: 3)),
        ])

        XCTAssertEqual(expectedTokens, tokens)
    }
}
