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
