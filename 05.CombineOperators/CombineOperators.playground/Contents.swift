import UIKit
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "prepend(Output...)") {
  // 1
  let publisher = [3, 4].publisher

  // 2
  publisher
    .prepend(1, 2)
    .prepend(-1, 0)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "prepend(Sequence)") {
  // 1
  let publisher = [5, 6, 7].publisher

  // 2
  publisher
    .prepend([3, 4])
    .prepend(Set(1...2))
    .prepend(stride(from: 6, to: 11, by: 2))
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "prepend(Publisher)") {
  // 1
  let publisher1 = [3, 4].publisher
  let publisher2 = [1, 5].publisher

  // 2
  publisher1
    .prepend(publisher2) // [1,5] 값이 prefix로 들어간다는걸 생각해야함
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "prepend(Publisher) #2") {
  // 1
  let publisher1 = [3, 4].publisher
  let publisher2 = PassthroughSubject<Int, Never>()

  // 2
  publisher1
    .prepend(publisher2)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)

  // 3
  publisher2.send(1)
  publisher2.send(2)

  publisher2.send(completion: .finished) // publisher2의 emit 완료가 진행되어야만 publisher1 값이 emit 된다.
}

example(of: "append(Output...)") {
  // 1
  let publisher = [1].publisher

  // 2
  publisher
    .append(2, 3)
    .append(4)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "append(Output...) #2") {
  // 1
  let publisher = PassthroughSubject<Int, Never>()

  publisher
    .append(3, 4)
    .append(5)
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)

  // 2. PassthroughSubject를 사용했기 때문에 .send 가 우선순위가 있는 상태이고 이게 끝났다는걸 .finished 로 명시해야만 append(3,4), append(5) 가 동작할 수 있다.
  publisher.send(1)
  publisher.send(2)
  publisher.send(completion: .finished)
}

example(of: "append(Sequence)") {
// As you can see, the execution of the appends is sequential as the previous publisher must complete before the next append performs.

  // 1
  let publisher = [1, 2, 3].publisher

  publisher
    .append([4, 5]) // 2
    .append(Set([6, 7])) // 3
    .append(stride(from: 8, to: 11, by: 2)) // 4
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "prepend(Publisher)") {
  // 1
  let publisher1 = [3, 4].publisher
  let publisher2 = [1, 2].publisher

  // 2
  publisher1
    .prepend(publisher2)    // publisher2 send .finished 가 되어야만 publisher1이 event를 emit 할 수 있다.
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
}

example(of: "prepend(Publisher) #2") {
  // 1
  let publisher1 = [3, 4].publisher
  let publisher2 = PassthroughSubject<Int, Never>()

  // 2
  publisher1
    .prepend(publisher2)    // Publisher2 가 선행한다. .finished 로 알려줘야 그제서야 publisher1이 진행될 수 있다.
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)

  // 3
  publisher2.send(1)
  publisher2.send(2)

  publisher2.send(completion: .finished)

}

example(of: "merge(with:)") {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()

  // 2
  publisher1
    .merge(with: publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },

example(of: "switchToLatest") {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<Int, Never>()
  let publisher3 = PassthroughSubject<Int, Never>()

  // 2
  let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()

  // 3
  publishers
    .switchToLatest()
    .sink(
      receiveCompletion: { _ in print("Completed!") },
      receiveValue: { print($0) }
    )
    .store(in: &subscriptions)

  // 3
  publisher1.send(1)
  publisher1.send(2)

  publisher2.send(3)

  publisher1.send(4)

  publisher2.send(5)

  // 4
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}


example(of: "combineLatest") {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()

  // 2
  publisher1
    .combineLatest(publisher2)
    .sink(
      receiveCompletion: { _ in print("Completed") },
      receiveValue: { print("P1: \($0), P2: \($1)") }
    )
    .store(in: &subscriptions)

  // 3
  publisher1.send(1)
  publisher1.send(2)
  
  publisher2.send("a")
  publisher2.send("b")
  
  publisher1.send(3)
  
  publisher2.send("c")

  // 4
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

example(of: "zip") {
  // 1
  let publisher1 = PassthroughSubject<Int, Never>()
  let publisher2 = PassthroughSubject<String, Never>()

  // 2
  publisher1
      .zip(publisher2)
      .sink(
        receiveCompletion: { _ in print("Completed") },
        receiveValue: { print("P1: \($0), P2: \($1)") }
      )
      .store(in: &subscriptions)

  // 3
  publisher1.send(1)
  publisher1.send(2)
  publisher2.send("a")
  publisher2.send("b")
  publisher1.send(3)
  publisher2.send("c")
  publisher2.send("d")

  // 4
  publisher1.send(completion: .finished)
  publisher2.send(completion: .finished)
}

      
  // 4
//  publishers.send(publisher1)
//  publisher1.send(1)
//  publisher1.send(2)
//
//  // 5
//  publishers.send(publisher2)   // publisher1에 대한 구독이 취소되었음을 알 수 있다.
//  publisher1.send(3)            // 그렇기 때문에 publisher1이 3을 보내도 무시된다.
//  publisher2.send(4)
//  publisher2.send(5)
//
//  // 6
//  publishers.send(publisher3)   // publisher2에 대한 구독이 취소되었음을 알 수 있다.
//  publisher2.send(6)            // 그렇기 때문에 publisher2가 6을 보내도 무시된다.
//  publisher3.send(7)
//  publisher3.send(8)
//  publisher3.send(9)
//
//  // 7
//  publisher3.send(completion: .finished)
//  publishers.send(completion: .finished)
//}

example(of: "switchToLatest - Network Request") {
  let url = URL(string: "https://source.unsplash.com/random")!

  // 1
  func getImage() -> AnyPublisher<UIImage?, Never> {
      URLSession.shared
        .dataTaskPublisher(for: url)
        .map { data, _ in UIImage(data: data) }
        .print("image")
        .replaceError(with: nil)
        .eraseToAnyPublisher()
  }

  // 2
  let taps = PassthroughSubject<Void, Never>()

  taps
    .map { _ in getImage() } // 3
    .switchToLatest() // 4
    .sink(receiveValue: { _ in })
    .store(in: &subscriptions)

  // 5
  taps.send()

  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    taps.send()
  }

  DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
    taps.send()
  }
}
