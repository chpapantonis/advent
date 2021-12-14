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



func makeData() -> (UInt16, [(UInt16,UInt16)], [(UInt16,UInt16)]) {
    let contents = load(file: file)
    guard let input = contents?.split(separator: "\n") else {
        fatalError()
    }

    var startingPoints: [(UInt16,UInt16)] = []
    var finishPoints: [(UInt16,UInt16)] = []
    var maxX: UInt16 = 0
    var maxY: UInt16 = 0

    input.forEach {
        if let range = $0.range(of: "->") {
            let firstPart = $0[($0.startIndex)..<range.lowerBound].trimmingCharacters(in: .whitespaces).split(separator: ",")
            let secondPart = $0[range.upperBound..<$0.endIndex].trimmingCharacters(in: .whitespaces).split(separator: ",")

            let startPoint = (UInt16(firstPart[0])!, UInt16(firstPart[1])!)
            let finishPoint = (UInt16(secondPart[0])!, UInt16(secondPart[1])!)

            startingPoints.append(startPoint)
            finishPoints.append(finishPoint)

            if startPoint.0 > maxX {
                maxX = startPoint.0
            }

            if finishPoint.0 > maxX {
                maxX = finishPoint.0
            }

            if startPoint.1 > maxY {
                maxY = startPoint.1
            }

            if finishPoint.1 > maxY {
                maxY = finishPoint.1
            }
        }
    }

    return (max(maxX, maxY), startingPoints, finishPoints)
}

func solution1() {
    let (dimension, startPoints, endPoints) = makeData()
    var map:[[UInt8]] = Array(repeating: Array(repeating: 0, count: Int(dimension + 1)), count: Int(dimension + 1))

    var dangerousPoints = 0

    for pointIdx in 0..<startPoints.count {
        let columnMin = Int(min(startPoints[pointIdx].1, endPoints[pointIdx].1))
        let columnMax = Int(max(startPoints[pointIdx].1, endPoints[pointIdx].1))
        let rowMin = Int(min(startPoints[pointIdx].0, endPoints[pointIdx].0))
        let rowMax = Int(max(startPoints[pointIdx].0, endPoints[pointIdx].0))

        guard columnMin == columnMax || rowMin == rowMax else { continue }

        for columnIdx in columnMin...columnMax {
            for rowIdx in rowMin...rowMax {
                map[columnIdx][rowIdx] += 1
            }
        }
    }

    map.forEach {
        $0.forEach {
            if $0 >= 2 { dangerousPoints += 1 }
        }
    }
    print(dangerousPoints)
}

func solution2() {
    let (dimension, startPoints, endPoints) = makeData()
    var map:[[UInt8]] = Array(repeating: Array(repeating: 0, count: Int(dimension + 1)), count: Int(dimension + 1))

    var dangerousPoints = 0

    for pointIdx in 0..<startPoints.count {
        let columnMin = Int(min(startPoints[pointIdx].1, endPoints[pointIdx].1))
        let columnMax = Int(max(startPoints[pointIdx].1, endPoints[pointIdx].1))
        let rowMin = Int(min(startPoints[pointIdx].0, endPoints[pointIdx].0))
        let rowMax = Int(max(startPoints[pointIdx].0, endPoints[pointIdx].0))

        if columnMin == columnMax || rowMin == rowMax {
            for columnIdx in columnMin...columnMax {
                for rowIdx in rowMin...rowMax {
                    map[columnIdx][rowIdx] += 1
                }
            }
        } else {
            var invertedDiagonal = false
            // Check whether we go NE or SW to calculate the inverted diagonal. Else calculate the normal one
            if (startPoints[pointIdx].0 > endPoints[pointIdx].0 && startPoints[pointIdx].1 < endPoints[pointIdx].1) ||
                startPoints[pointIdx].0 < endPoints[pointIdx].0 && startPoints[pointIdx].1 > endPoints[pointIdx].1 {
                invertedDiagonal = true
            }

            let value = startPoints[pointIdx].0 + startPoints[pointIdx].1

            for columnIdx in columnMin...columnMax {
                for rowIdx in rowMin...rowMax {
                    if invertedDiagonal {
                        if columnIdx + rowIdx == value {
                            map[columnIdx][rowIdx] += 1
                        }
                    } else {
                        if columnIdx - columnMin == rowIdx - rowMin {
                            map[columnIdx][rowIdx] += 1
                        }
                    }
                }
            }
        }
    }

    map.forEach {
        $0.forEach {
            if $0 >= 2 { dangerousPoints += 1 }
        }
    }
    print(dangerousPoints)
}


solution2()
