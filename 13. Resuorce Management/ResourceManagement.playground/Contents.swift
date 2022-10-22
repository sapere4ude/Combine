import Combine
import Foundation


// share()
//let shared = URLSession.shared
//  .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
//  .map(\.data)
//  .print("shared")
//  .share()
//
//print("subscribing first")

//let subscription1 = shared.sink(
//  receiveCompletion: { _ in },
//  receiveValue: { print("subscription1 received: '\($0)'") }
//)
//
//print("subscribing second")
//
//let subscription2 = shared.sink(
//  receiveCompletion: { _ in },
//  receiveValue: { print("subscription2 received: '\($0)'") }
//)

// multicast()
// 1
let subject = PassthroughSubject<Data, URLError>() // cf. subject는 원하는 값을 주입할 수 있는 publihser

// 2
let multicasted = URLSession.shared
  .dataTaskPublisher(for: URL(string: "https://www.raywenderlich.com")!)
  .map(\.data)
  .print("multicast")
  .multicast(subject: subject)

// 3
let subscription1 = multicasted
  .sink(
    receiveCompletion: { _ in },
    receiveValue: { print("subscription1 received: '\($0)'") }
  )

let subscription2 = multicasted
  .sink(
    receiveCompletion: { _ in },
    receiveValue: { print("subscription2 received: '\($0)'") }
  )

// 4
let cancellable = multicasted.connect()

