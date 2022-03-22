import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence

/// Takes the power of `power` from `radix`
/// e.g. 
/// ```swift
/// 2^^8 // 256
/// ```
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}

