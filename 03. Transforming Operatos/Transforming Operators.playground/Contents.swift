import UIKit
import Combine
import Foundation

var subscriptions = Set<AnyCancellable>()

example(of: "collect") {
    ["A", "B", "C", "D", "E"].publisher
        .collect()
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "map") {
    // 1
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    // 2
    [123, 4, 56].publisher
        // 3
        .map {
            formatter.string(for: NSNumber(integerLiteral: $0)) ?? ""
        }
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "tryMap") {
  // 1
  Just("Directory name that does not exist")
    // 2
    .tryMap { try FileManager.default.contentsOfDirectory(atPath: $0) }
    // 3
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print($0) })
    .store(in: &subscriptions)
}

/// tryMap test
enum KantError: Error {
    case elementIsNil
}

func checkNil(element: Int?) throws -> Int {
    guard let element = element else {
        throw KantError.elementIsNil
    }
    return element
}

let publisher = [1, 2, nil, 4].publisher
//let publisher = [1, 2, 4].publisher

publisher
    .tryMap { try checkNil(element: $0) }
    .sink(receiveCompletion: {
        switch $0 {
        case .failure(let error):
            print(error.localizedDescription)
        case .finished:
            print("끝입니다")
        }
    }, receiveValue: { print($0) })

/// flatMap
example(of: "flatMap") {
  // 1
  func decode(_ codes: [Int]) -> AnyPublisher<String, Never> {
    // 2
    Just(
      codes
        .compactMap { code in
          guard (32...255).contains(code) else { return nil }
          return String(UnicodeScalar(code) ?? " ")
        }
        // 3
        .joined()
    )
    // 4
    .eraseToAnyPublisher()
  }
    
    // 5
    [72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33]
      .publisher
      .collect()
      // 6
      .flatMap(decode)
      // 7
      .sink(receiveValue: { print($0) })
      .store(in: &subscriptions)
}

// replaceNil(with:)
example(of: "replaceNil") {
    ["A", nil, "C"].publisher
        .eraseToAnyPublisher()
        .replaceNil(with: "-")
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "replaceEmpty(with:)") {
    let empty = Empty<Int, Never>()
    
    empty
        .replaceEmpty(with: 1)
        .sink(receiveCompletion: { print($0) },
              receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "scan") {
  // 1
  var dailyGainLoss: Int { .random(in: -10...10) }

  // 2
  let august2019 = (0..<22)
    .map { _ in dailyGainLoss }
    .publisher

  // 3
  august2019
    .scan(50) { latest, current in
      max(0, latest + current)
    }
    .sink(receiveValue: { _ in })
    .store(in: &subscriptions)
}

example(of: "scan sample2") {
    let publisher = [1,2,3,4,5].publisher
    publisher
        .scan(0) { latest, current in
            print("latest: \(latest), current: \(current)")
            return latest + current
        }
        .sink(receiveValue: { print($0) })
}


