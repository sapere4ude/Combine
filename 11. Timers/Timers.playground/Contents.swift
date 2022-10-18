import Combine
import Foundation

var subscriptions = Set<AnyCancellable>()

let runLoop = RunLoop.main

//let subscription = runLoop.schedule(
//    after: runLoop.now,
//    interval: .seconds(1),
//    tolerance: .milliseconds(100)
//) {
//    print("Timer fired")
//}

subscription.store(in: &subscriptions)

runLoop.schedule(after: .init(Date(timeIntervalSinceNow: 3.0))) {
    subscription.cancel()
}

let main = Timer.publish(every: 1.0, on: .main, in: .common)
let current = Timer.publish(every: 1.0, on: .current, in: .common)

//let subscription = Timer
//  .publish(every: 1.0, on: .main, in: .common)
//  .autoconnect()
//  .scan(0) { counter, _ in counter + 1 }
//  .sink { counter in
//    print("Counter is \(counter)")
//  }

let queue = DispatchQueue.main

// 1
let source = PassthroughSubject<Int, Never>()

// 2
var counter = 0

// 3
let cancellable = queue.schedule(
  after: queue.now,
  interval: .seconds(1)
) {
  source.send(counter)
  counter += 1
}

// 4
let subscription = source.sink {
  print("Timer emitted \($0)")
}

