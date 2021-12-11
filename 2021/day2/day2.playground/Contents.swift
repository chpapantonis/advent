import UIKit

func load(file named: String) -> String? {
    guard let fileUrl = Bundle.main.url(forResource: named, withExtension: "txt") else {
        return nil
    }

    guard let content = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        return nil
    }

    return content
}

let file = "instructions"

let contents = load(file: file)
let instructions = contents?.split(separator: "\n").compactMap { $0.split(separator: " ") }

var depth = 0
var forward = 0
// first answer
instructions?.forEach {
    let movement = $0[0]
    switch movement {
        case "forward":
            forward += Int($0[1])!
        case "up":
            depth -= Int($0[1])!
        case "down":
            depth += Int($0[1])!
        default:
            print("nothing")
    }
}
var multiply = forward * depth
print(multiply)

// 2nd answer
forward = 0
depth = 0
var aim = 0

instructions?.forEach {
    let movement = $0[0]
    switch movement {
        case "forward":
            forward += Int($0[1])!
            depth += aim * Int($0[1])!
        case "up":
            aim -= Int($0[1])!
        case "down":
            aim += Int($0[1])!
        default:
            print("nothing")
    }
}

multiply = forward * depth
print(multiply)


