#if canImport(Darwin)
import Darwin
#else
import Foundation
#endif

func eprint(_ text: String) {
    let errorMessage = "\u{001b}[31mERROR\u{001b}[0m: \(text)"
    #if canImport(Darwin)
    fputs(errorMessage, stderr)
    #else
    if #available(macOS 10.15.4, *) { 
        do {
            try errorMessage
                .data(using: .utf8)
                .map({try FileHandle.standardError.write(contentsOf: $0)})
        } catch(let err) {
            fatalError(err.localizedDescription)
        }
    }
    #endif
}