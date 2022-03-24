// Flags have higher priority than environment variables

// --enable-visual-input OR --enable-visual-input=TRUE OR VISUAL_INPUT=TRUE
// --array-size=30000 OR ARRAY_SIZE=30000

// --visual-array
// --visual-execution // Show where in the source code the program currently is
// --visual-debug-dont-erase // Don't erase the previous array and visual execution when printing the next
// --step-debug or -S // Execute step by step. Execute next on return.
// --visual-debug or -D // visual-execution=TRUE, visual-array=TRUE & step-debug=TRUE

// TODO
// -v : visual
// -va = visual array
// -vae = visual array, visual execution
// -vd = don't erase

// --cell-size=8 (8bits) OR CELL_SIZE=8
// --comments OR -c // Don't execute everything after ;;
// --comments="//" // Don't execute everything after //

// --number-mode // Show numbers as output instead of text

// --help or -h

import Foundation
#if canImport(Darwin)
import Darwin
#endif
import ArgumentParser
import BrainfuckRun
import struct BrainfuckCore.FileHandleOutputStream
import protocol BrainfuckCore.InputStream
import struct BrainfuckCore.StdInStream
import struct BrainfuckCore.StringInputStream

// The brainfuck CLI
struct BrainfuckCLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A brianfuck interpreter",
        version: "1.0.0",
        subcommands: [Run.self]
    )
}

fileprivate enum InputStreamType {
    case StdIn(stream: StdInStream)
    case String(stream: StringInputStream)
}

/// # Run subcommand
/// Interprets a brainfuck sourcre file
struct Run: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Run a brainfuck file")

    @OptionGroup var options: RunOptions

    mutating func run() throws {
        var interpretOpts = InterpretOptions(options: [])

        // Parse options
        if self.options.enable_visual_input { interpretOpts.options.insert(.visualInput) }
        interpretOpts.options.insert(.arraySize(size: self.options.array_size))
        if self.options.visual_debug {
            if self.options.visual_array { interpretOpts.options.insert(.visualArray) }
            if self.options.visual_execution { interpretOpts.options.insert(.visualExecution) }
            if self.options.step_debug { interpretOpts.options.insert(.stepDebug) }
        } else {
            interpretOpts.options.insert(.visualArray)
            interpretOpts.options.insert(.visualExecution)
            interpretOpts.options.insert(.stepDebug)
        }
        if self.options.visual_debug_dont_erase { interpretOpts.options.insert(.visualDebugDontErase) }
        interpretOpts.options.insert(.cellSize(size: self.options.cell_size))
        if let comments = self.options.comments { interpretOpts.options.insert(.comments(syntax: comments)) }
        if self.options.number_mode { interpretOpts.options.insert(.numberMode) }

        // TOODO is readLine, StringInputStream
        var stdout = FileHandleOutputStream(FileHandle.standardOutput, name: "stdout")
        // Handle pipedInput
        var inStream: InputStreamType
        if isatty(FileHandle.standardInput.fileDescriptor) != 1 {
            // Input is being piped to the program
            var allInput = ""
            while let nextLine = readLine(strippingNewline: false) {
                allInput.append("\(nextLine)")
            }
            allInput.append("\u{00}") // End input
            inStream = .String(stream: StringInputStream(allInput))
        } else {
            // No pipe; read from stdin
            inStream = .StdIn(stream: StdInStream())
        }
        var stderr = FileHandleOutputStream(FileHandle.standardError, name: "stderr")

        // Execute brainfuck
        if FileManager.default.fileExists(atPath: self.options.file) {
            let sourceCodeString = try NSString(contentsOfFile: self.options.file, encoding: String.Encoding.utf8.rawValue) as String
            switch inStream {
            case .StdIn(stream: let inS):
                try BrainfuckRun.run(
                    source: sourceCodeString, 
                    options: interpretOpts,
                    outStream: &stdout,
                    errStream: &stderr,
                    inStream: inS
                )
            case .String(stream: let inS):      
                try BrainfuckRun.run(
                    source: sourceCodeString,
                    options: interpretOpts,
                    outStream: &stdout,
                    errStream: &stderr,
                    inStream: inS
                )
            }
        } else {
            let errorMessage = "The file \(self.options.file) does not exist or is not a file\n"
            eprint(errorMessage)
        }
    }
}

struct RunOptions: ParsableArguments {
    @Argument(
        help: "The source file to run", 
        completion: .file(extensions: [".bf"]))
    var file: String

    @Flag(
        name: [.customLong("visual-input")], 
        help: "Shows a '>' when asking for input")
    var enable_visual_input: Bool = false

    @Option(
        name: [.customLong("array-size"), .customShort("s")],
        help: "Set the size of the array")
    var array_size: Int = 30_000

    @Flag(
        name: [.customLong("visual-array")],
        help: "Show the array while the program is executing")
    var visual_array = false

    @Flag(
        name: [.customLong("visual-execution")],
        help: "Show where the program is in the source code")
    var visual_execution = false

    @Flag(
        name: [.customLong("visual-debug-dont-erase")],
        help: "Leave the previous array and/or line in the program (if set with --visual-array and --visual-execution) instead of overwriting")
    var visual_debug_dont_erase = false

    @Flag(
        name: [.customLong("step-debug"), .customShort("S")],
        help: "Execute the program step by step. Only continue to the next command when return is pressed")
    var step_debug = false

    @Flag(
        name: [.customLong("visual-debug"), .customShort("D")],
        help: "Shorthand for setting visual-execution, visual-array and step-debug")
    var visual_debug = false

    @Option(
        name: [.customLong("cell-size"), .customShort("C")],
        help: "Sets the amount of bits that can be stored in a cell")
    var cell_size = 8

    // TODO
    @Option(
        name: [.customLong("comments"), .customShort("c")],
        help: "Don't execute code after ';;', or after custom comment syntax")
    var comments: String?

    @Flag(
        name: [.customLong("number-mode"), .customShort("n")],
        help: "Shows cells as numbers in output instead of text")
    var number_mode = false
}
