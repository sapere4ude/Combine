import Combine
import Foundation

var subscriptions = Set<AnyCancellable>()

enum MyError: Error {
  case ohNo
}

example(of: "setFailureType") {
    Just("Hello")
    .setFailureType(to: MyError.self)
    // 1
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


