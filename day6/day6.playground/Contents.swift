import UIKit

let file = "data"

func load(file named: String) -> String? {
    guard let fileUrl = Bundle.main.url(forResource: named, withExtension: "txt") else {
        return nil
    }

    guard let content = try? String(contentsOf: fileUrl, encoding: .utf8) else {
        return nil
    }

    return content
}

func makeData() -> [Int] {
    let contents = load(file: file)
    guard let input = contents?.split(separator: "\n") else {
        fatalError()
    }
    return input[0].split(separator: ",").compactMap { Int($0) }
}


func solution(days: Int) {
    let fishArr: [Int] = makeData()
    var fishBucket:[Int] = Array(repeating: 0, count: 9)

    fishArr.forEach { fishBucket[$0] += 1 }

    for _ in 0..<days {
        let newFish = fishBucket[0]
        for idx in 0..<fishBucket.count {
            if idx + 1 < fishBucket.count {
                fishBucket[idx] = fishBucket[idx + 1]
            } else {
                fishBucket[idx] = newFish
            }
        }
        fishBucket[6] += newFish
    }

    var total = 0
    fishBucket.forEach { total += $0 }
    print(total)
}

solution(days: 80)
solution(days: 256)
