# BrainfuckSwift

A brainfuck interpreter written in Swift.

## Usage

The interpreter can be used as a package or using the CLI.

### CLI
```bash
$ brainfuck run Examples/hello_world.bf
Hello world
```

**Download**
You can download the CLI for macOS and Linux from the [releases](https://github.com/Jomy10/BrainfuckSwift/releases).

Alternatively, you can compile the binary yourself:

```bash
git clone https://github.com/Jomy10/BrainfuckSwift
cd BrainfuckSwift
swift build --configuration release --show-bin-path
```

For a list of features currently support by the CLI, see the [README in the examples folder](Examples/README.md).

### Pacakge
You can add either the `BrainfuckCore` or the `BrainfuckRun` (or both) to your project.

```swift
// Package.swift

// ...
dependencies: [
    .package(url: "https://github.com/Jomy10/BrainfuckSwift", branch: "master")
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .produt(name: "BrainfuckCore", package: "BrainfuckSwift"),
            .produt(name: "BrainfuckRun", package: "BrainfuckSwift")
        ]
    )
]
// ...
```

#### Usage
The following two examples are equivalent

**BrainfuckRun**
```swift
import BrainfuckRun

var stdout = FileHandleOutputStream(FileHandle.standardOutput)
var stderr = FileHandleOutputStream(FileHandle.standardError)
let stdin = StdInStream()

BrainfuckRun.run(
    source: "+[,.]", // Cat program as strin
    options: [.visualInput],
    outStream: &stdout,
    errStream: &stderr,
    inStream: stdin
)
```

```bash
$ swift run
> Test
Test
# ...
```

**BrainfuckCore**
```swift
import BrainfuckCore

var stdout = FileHandleOutputStream(FileHandle.standardOutput)
var stderr = FileHandleOutputStream(FileHandle.standardError)
let stdin = StdInStream()

let tokens = Tokenizer.tokenize(source: "+[,.]")
var tokenIter = tokens.makeIterator()
let tree = Tree(tokens: &tokenIter)

Interpreter(tree: tree, options: [.visualInput])
    .exec(outputStream: &stdout, errorStream: &stderr, inputStream: stdin)
```

```bash
$ swift run
> Test
Test
# ...
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## Running tests

To test the package, simply run `swift run`

## License

This package and CLI are licensed under the [`MIT` license](LICENSE)
