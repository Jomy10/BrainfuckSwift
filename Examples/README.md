Use the CLI to execute these programs in different ways:

## Basic usage
```bash
$ brainfuck run Examples/hello_world.bf
Hello world
```

## Visual input

The `--visual-input` flag will show a `>` when asking for input

```bash
$ brainfuck run Examples/cat.bf --visual-input
> This is input from the user
This is input from the user
> A simple cat program!
A simple cat program!
```
 
## Piping
```bash
$ echo "Hello world!" | brainfuck run Examples/cat.bf
Hello world!
```

```bash
$ curl "https://gist.githubusercontent.com/ElliotGluck/64b0b814293c09999f765e265aaa2ba1/raw/79f24f9f87654d7ec7c2f6ba83e927852cdbf9a5/gistfile1.txt" | ./.build/debug/Brainfuck run Examples/cat.bf
# The bee movie script
```

## Comments (unimplemented)

`--comments ";;"` will remove everything after `;;` in the source code

## Number mode (unimplemented)

`--number-mode` will output numbers instead of text

## Debugging (unimplemented)

`--visual-array` will show the array and the pointer
`--visual-execution` will show the point in the source code where the program is currently
`--step-debug` will execute the next character in the program when the return key is pressed

`--visual-debug` will set all of the above to true

`--visual-debug-dont-erase` won't erase the previous array and source code and instead start a new line

## Array size

`array-size <array-size>` will set the size of the array (default is 30000)

## Cell size (unimplemented)

`cell-size <cell-size>` will set the amount of bits that can be stored in a single cell
