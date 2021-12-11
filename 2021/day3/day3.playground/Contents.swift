import UIKit
import Foundation

func load(file named: String) -> String? {
    guard let fileUrl = Bundle.main.url(forResource: named, withExtension: "txt") else {
        return nil
    }

    guard let content = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        return nil
    }

    return content
}

let file = "bits"

let contents = load(file: file)

var twosComplement:[Int16] = []

guard let bits = contents?.split(separator: "\n").compactMap({Array($0)}) else {
    fatalError()
}

let stringSize = bits[0].count
let arraySize = bits.count

var gammaRate: [Character] = []
var epsilonRate: [Character] = []

for bitIdx in 0..<stringSize {
    var ones = 0
    var zeros = 0
    for stringIdx in 0..<arraySize {
        if bits[stringIdx][bitIdx] == "1" {
            ones += 1
        } else {
            zeros += 1
        }
    }

    let mostFreq: Character = ones > zeros ? "1" : "0"
    let lessFreq: Character = ones > zeros ? "0" : "1"
    gammaRate.append(mostFreq)
    epsilonRate.append(lessFreq)
}

print(gammaRate)
print(epsilonRate)
let multiply = Int(String(gammaRate), radix: 2)! * Int(String(epsilonRate), radix: 2)!
print(multiply)

