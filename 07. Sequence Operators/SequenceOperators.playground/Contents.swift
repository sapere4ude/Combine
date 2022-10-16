import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "min") {
  // 1
  let publisher = [1, -50, 246, 0].publisher

  // 2
  publisher
    .print("publisher")
    .min()
    .sink(receiveValue: { print("Lowest value is \($0)") })
    .store(in: &subscriptions)
}

example(of: "min non-Comparable") {
  // 1
  let publisher = ["12345",
                   "ab",
                   "hello world"]
    .map { Data($0.utf8) } // [Data]
    .publisher // Publisher<Data, Never>

  // 2
  publisher
    .print("publisher")
    .min(by: { $0.count < $1.count })
    .sink(receiveValue: { data in
      // 3
      let string = String(data: data, encoding: .utf8)!
      print("Smallest data is \(string), \(data.count) bytes")
    })
    .store(in: &subscriptions)
}

example(of: "max") {
  // 1
  let publisher = ["A", "F", "Z", "E"].publisher

  // 2
  publisher
    .print("publisher")
    .max()
    .sink(receiveValue: { print("Highest value is \($0)") })
    .store(in: &subscriptions)
}

example(of: "first") {
  // 1
  let publisher = ["A", "B", "C"].publisher

  // 2
  publisher
    .print("publisher")
    .first()
    .sink(receiveValue: { print("First value is \($0)") })
    .store(in: &subscriptions)
}

example(of: "first(where:)") {
  // 1
  let publisher = ["J", "O", "H", "N"].publisher

  // 2
  publisher
    .print("publisher")
    .first(where: { "Hello World".contains($0) })
    .sink(receiveValue: { print("First match is \($0)") })
    .store(in: &subscriptions)
}

example(of: "last") {
  // 1
  let publisher = ["A", "B", "C"].publisher

  // 2
  publisher
    .print("publisher")
    .last()
    .sink(receiveValue: { print("Last value is \($0)") })
    .store(in: &subscriptions)
}

example(of: "output(at:)") {
  // 1
  let publisher = ["A", "B", "C"].publisher

  // 2
  publisher
    .print("publisher")
    .output(at: 1)
    .sink(receiveValue: { print("Value at index 1 is \($0)") })
    .store(in: &subscriptions)
}

example(of: "output(in:)") {
  // 1
  let publisher = ["A", "B", "C", "D", "E"].publisher

  // 2
  publisher
    .output(in: 1...3)
    .sink(receiveCompletion: { print($0) },
          receiveValue: { print("Value in range: \($0)") })
    .store(in: &subscriptions)
}

example(of: "count") {
  // 1
  let publisher = ["A", "B", "C"].publisher
    
  // 2
  publisher
    .print("publisher")
    .count()
    .sink(receiveValue: { print("I have \($0) items") })
    .store(in: &subscriptions)
}

example(of: "contains") {
  // 1
  let publisher = ["A", "B", "C", "D", "E"].publisher
  let letter = "C"

  // 2
  publisher
    .print("publisher")
    .contains(letter)
    .sink(receiveValue: { contains in
      // 3
      print(contains ? "Publisher emitted \(letter)!"
                     : "Publisher never emitted \(letter)!")
    })
    .store(in: &subscriptions)
}

example(of: "contains(where:)") {
  // 1
  struct Person {
    let id: Int
    let name: String
  }

  // 2
  let people = [
    (123, "Shai Mishali"),
    (777, "Marin Todorov"),
    (214, "Florent Pillet")
  ]
  .map(Person.init)
  .publisher

  // 3
  people
    .contains(where: { $0.id == 214 })
    .sink(receiveValue: { contains in
      // 4
      print(contains ? "Criteria matches!"
                     : "Couldn't find a match for the criteria")
    })
    .store(in: &subscriptions)
}

example(of: "allSatisfy") {
  // 1
  let publisher = stride(from: 0, to: 5, by: 2).publisher
  
  // 2
  publisher
    .print("publisher")
    .allSatisfy { $0 % 2 == 0 }
    .sink(receiveValue: { allEven in
      print(allEven ? "All numbers are even"
                    : "Something is odd...")
    })
    .store(in: &subscriptions)
}

example(of: "reduce") {
  // 1
  let publisher = ["Hel", "lo", " ", "Wor", "ld", "!"].publisher
  
  publisher
    .print("publisher")
    .reduce("") { accumulator, value in
      // 2
      accumulator + value
    }
    .sink(receiveValue: { print("Reduced into: \($0)") })
    .store(in: &subscriptions)
}
