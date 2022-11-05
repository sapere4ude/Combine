import Combine
import Foundation

var subscriptions = Set<AnyCancellable>()

enum MyError: Error {
  case ohNo
}

example(of: "setFailureType") {
    Just("Hello")
    .setFailureType(to: MyError.self)
}

example(of: "assertNoFailure") {
  // 1
  Just("Hello")
    .setFailureType(to: MyError.self)
    .assertNoFailure() // 2
    .sink(
      receiveCompletion: { completion in
        switch completion {
        // 2
        case .failure(.ohNo):
          print("Finished with Oh No!")
        case .finished:
          print("Finished successfully!")
        }
      },
      receiveValue: { value in
        print("Got value: \(value)")
      }
    )
    .store(in: &subscriptions)
}

example(of: "assign(to:on:)") {
  // 1
  class Person {
    let id = UUID()
    var name = "Unknown"
  }

  // 2
  let person = Person()
  print("1", person.name)

  Just("Shai")
    .handleEvents( // 3
      receiveCompletion: { _ in print("2", person.name) }
    )
    .assign(to: \.name, on: person) // 4
    .store(in: &subscriptions)
}

example(of: "assertNoFailure") {
  // 1
  Just("Hello")
    .setFailureType(to: MyError.self)
    .assertNoFailure() // 2
    .sink(receiveValue: { print("Got value: \($0) ")}) // 3
    .store(in: &subscriptions)
}

example(of: "tryMap") {
  // 1
  enum NameError: Error {
    case tooShort(String)
    case unknown
  }

  // 2
  let names = ["Marin", "Shai", "Florent"].publisher
  
  names
    .map { value -> Int in
        // 1
        let length = value.count
        // 2
        guard length >= 5 else {
            throw NameError.tooShort(value)
        }
        // 3
        return value.count
    }
    .sink(
      receiveCompletion: { print("Completed with \($0)") },
      receiveValue: { print("Got value: \($0)") }
    )
}

example(of: "map vs tryMap") {
  // 1
  enum NameError: Error {
    case tooShort(String)
    case unknown
  }

  // 2
  Just("Hello")
    .setFailureType(to: NameError.self) // 3
    .map { $0 + " World!" } // 4
    .sink(
      receiveCompletion: { completion in
        // 5
        switch completion {
        case .finished:
          print("Done!")
        case .failure(.tooShort(let name)):
          print("\(name) is too short!")
        case .failure(.unknown):
          print("An unknown name error occurred")
        }
      },
      receiveValue: { print("Got value \($0)") }
    )
    .store(in: &subscriptions)
}

