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

let file = "depths"

let contents = load(file: file)
let depths = contents?.split(separator: "\n").compactMap { Int($0) }
var increased = 0
var slidingWindowIncreases = 0

if let depths = depths {
    let arrSize = depths.count
    // First answer
    for idx in 1..<arrSize {
        if depths[idx] > depths[idx - 1] {
            increased += 1
        }
    }
    print(increased)

    
    //Second answer
    for idx in 1..<arrSize {
        if idx + 2 >= arrSize {
            break
        }

        let runningWindow = depths[idx] + depths[idx + 1] + depths[idx + 2]
        let previousWindow = depths[idx - 1] + depths[idx] + depths[idx + 1]

        if runningWindow > previousWindow { slidingWindowIncreases += 1 }
    }

    print (slidingWindowIncreases)
}






