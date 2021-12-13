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

func makeData(array: [Substring]) -> ([UInt8], [[[UInt8]]], [[[UInt8]]]) {
    var temp = array
    let drawn = temp.removeFirst().split(separator: ",").compactMap { UInt8(String($0)) }

    var played: [[[UInt8]]] = Array(repeating: Array(repeating: Array(repeating: 0, count: 5), count: 5), count: temp.count / 5)
    var playedTransposed: [[[UInt8]]] = Array(repeating: Array(repeating: Array(repeating: 0, count: 5), count: 5), count: temp.count / 5)

    for (idx, row) in temp.enumerated() {
        let arrayIndex = idx / 5
        let rowIndex = idx % 5
        let rowNumbers = row.split(separator: " ")
        for (columnIdx, number) in rowNumbers.enumerated() {
            played[arrayIndex][rowIndex][columnIdx] = UInt8(String(number))!
            playedTransposed[arrayIndex][columnIdx][rowIndex] = UInt8(String(number))!
        }
    }
    return (drawn, played, playedTransposed)
}

func score(bingoBord: [[UInt8]], numbers: Set<UInt8>, bingoNumber: UInt8) -> Int {
    var sum = 0
    bingoBord.forEach {
        $0.forEach {
            if !numbers.contains($0) {
                sum += Int($0)
            }
        }
    }
    return sum * Int(bingoNumber)
}

func solution1() -> Int {
    let contents = load(file: file)
    guard let input = contents?.split(separator: "\n") else {
        fatalError()
    }

    let (drawn, played, playedTransposed) = makeData(array: input)

    var winningNumbers: Set = Set(drawn[0...4])
    var winnerSet: Int = 1000000
    var last: UInt8 = 255

    outerLoop: for idx in 4..<drawn.count {
        for dataSetIdx in 0..<played.count {
            for rowIndex in 0..<played[dataSetIdx].count {
                var runningNumbers = Set(played[dataSetIdx][rowIndex])
                if runningNumbers.isSubset(of: winningNumbers) {
                    winnerSet = dataSetIdx
                    break outerLoop
                }
                runningNumbers = Set(playedTransposed[dataSetIdx][rowIndex])
                if runningNumbers.isSubset(of: winningNumbers) {
                    winnerSet = dataSetIdx
                    break outerLoop
                }
            }
        }
        if idx + 1 < drawn.count {
            last = drawn[idx + 1]
            winningNumbers.insert(last)
        }
    }

    return score(bingoBord: played[winnerSet], numbers: winningNumbers, bingoNumber: last)
}

func solution2() -> Int {
    let contents = load(file: file)
    guard let input = contents?.split(separator: "\n") else {
        fatalError()
    }
    let (drawn, played, playedTransposed) = makeData(array: input)
    var last: UInt8 = 255
    var orderedWinningBorards: [Int] = []
    var winningArr: [UInt8] = Array(drawn[0...4])
    var scores: [(Int, Int)] = []

    for idx in 4..<drawn.count {
        for dataSetIdx in 0..<played.count {
            if orderedWinningBorards.contains(dataSetIdx) { continue }
            for rowIndex in 0..<played[dataSetIdx].count {
                let runningNormalNumbers = Set(played[dataSetIdx][rowIndex])
                let runningTransposedNumbers = Set(playedTransposed[dataSetIdx][rowIndex])
                if runningNormalNumbers.isSubset(of: Set(winningArr)) || runningTransposedNumbers.isSubset(of: Set(winningArr)) {
                    orderedWinningBorards.append(dataSetIdx)
                    scores.append((dataSetIdx, score(bingoBord: played[dataSetIdx], numbers: Set(winningArr), bingoNumber: last)))
                }
            }
        }
        if idx + 1 < drawn.count {
            last = drawn[idx + 1]
            winningArr.append(last)
        }
    }
    return scores.last?.1 ?? 0
}

print(solution2())
