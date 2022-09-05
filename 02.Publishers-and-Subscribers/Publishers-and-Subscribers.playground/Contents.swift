import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()

example(of: "Publisher") {
    // 1
    let myNotification = Notification.Name("MyNotification")
    
    // 2
    let publisher = NotificationCenter.default
        .publisher(for: myNotification, object: nil)
    
    // 3
    let center = NotificationCenter.default
    
    // 4
    let observer = center.addObserver(
        forName: myNotification,
        object: nil,
        queue: nil) { notification in
            print("Notification received!")
        }
    
    // 5
    center.post(name: myNotification, object: nil)
    
    // 6
    center.removeObserver(observer)
}

example(of: "Subscriber") {
    
    let myNotification = Notification.Name("MyNotification")
    
    let center = NotificationCenter.default
    
    let publisher = center.publisher(for: myNotification, object: nil)
    
    let subscription = publisher.sink { _ in
        print("Notification received from a publisher!")
    }
    
    center.post(name: myNotification, object: nil)
    
    subscription.cancel()
}

example(of: "Just") {
    let just = Just("Hello world!")
    
    _ = just
        .sink(receiveCompletion: {
            print("Received completion", $0)
        }, receiveValue: {
            print("Received value", $0)
        })
}

example(of: "assign(to:on)") {
    class SomeObjecet {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    let object = SomeObjecet()
    
    let publisher = ["Hello","world!"].publisher
    
    _ = publisher.assign(to: \.value, on: object)
}

example(of: "assign(to:)") {
    class SomeObject {
        @Published var value = 0
    }
    
    let object = SomeObject()
    
    object.$value
        .sink {                     // sink 를 통한 구독
            print($0)
        }
    
    (0..<10).publisher
        .assign(to: &object.$value) // assign 을 통한 재구독
    
    print("object.value:\(object.value)") // 9 <- 마지막 숫자가 나오는걸 확인할 수 있음
}

//public protocol Publisher {
//    // 1. Publisher가 생성할 수 있는 값의 유형
//    associatedtype Output
//
//    // 2. Publisher가 생성할 수 있는 오류 유형. 오류가 생성되지 않는걸 보장하는 건 Never 를 사용하면 된다.
//    associatedtype Failure : Error
//
//    // 4. subscribe(_:) 실행으로 subscriber가 publisher에 연결될 수 있게 된다. 이것이 subscription 이다.
//    func receive<S>(subscriber: S)
//     where S: Subscriber,
//     Self.Failure == S.Failure
//     Self.Output == S.Output
//}
//
//extension Publisher {
//    // 3. subscriber는 publisher에 대해 subscribe(_:)를 호출하여 접근
//    public func subscribe<S>(_ subscriber: S)
//     where S: Subscriber,
//     Self.Failure == S.Failure,
//     Self.Output == S.Input
//}

//public protocol Subscriber: CustomCombineIdentifierConvertible {
//  // 1. subscriber 가 받을 수 있는 값의 유형
//  associatedtype Input
//
//  // 2
//  associatedtype Failure: Error
//
//  // 3. publisher는 subscriber에 대해 receive(subscription:)을 호출하여 subscription을 제공
//  func receive(subscription: Subscription)
//
//  // 4. publisher는 subscriber에 대해 receive(:)를 호출하여 방금 게시한 새 값(published)을 subscriber에게 전달
//  func receive(_ input: Self.Input) -> Subscribers.Demand
//
//  // 5. publisher는 subscriber에 대해 receive(completion:)를 호출하여 정상 or 오류 값 생성이 완료되었음을 알린다.
//  func receive(completion: Subscribers.Completion<Self.Failure>)
//}

example(of: "Custom Subscriber") {
    // 1.
    //let publisher = (1...6).publisher
    let publisher = ["A","B","C","D","E","F"].publisher
    
    // 2.
    final class IntSubscriber: Subscriber {
        // 3.
        //typealias Input = Int
        typealias Input = String
        typealias Failure = Never
        
        // 4.
        func receive(subscription: Subscription) {
            subscription.request(.max(3))
        }
        
        // 5.
        //func receive(_ input: Int) -> Subscribers.Demand {
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            return .max(1)
        }
        
        // 6.
        func receive(completion: Subscribers.Completion<Never>) {
            print("Received completion", completion)
        }
    }
    
    let subscriber = IntSubscriber()
    
    publisher.subscribe(subscriber)
}

example(of: "Future") {
    func futureIncrement(integer: Int, afterDelay delay: TimeInterval) -> Future<Int, Never> {
        Future<Int, Never> { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                promise(.success(integer + 1))
            }
        }
    }
}

example(of: "PassThroughSubject") {
    // 1
    enum MyError: Error {
        case test
    }
    
    // 2
    final class StringSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription) {
            subscription.request(.max(2))
        }
        
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            //3
            return input == "World" ? .max(1) : .none
        }
        
        func receive(completion: Subscribers.Completion<MyError>) {
            print("Received completion", completion)
        }
    }
    
    // 4
    let subscriber = StringSubscriber()
    
    // 5
    let subject = PassthroughSubject<String, MyError>() // PassthroughSubject는 Combine 기본 함수
    
    // 6
    subject.subscribe(subscriber)
    
    let subscription = subject
        .sink { completion in
            print("Received completion (sink)", completion)
        } receiveValue: { value in
            print("Received value (sink)", value)
        }
    
    subject.send("Hello")
    subject.send("World")
    
    subscription.cancel()
    
    subject.send("Still there?")
    
    subject.send(completion: .failure(MyError.test))
    
    subject.send(completion: .finished)
    subject.send("How about another one?")
}

example(of: "CurrentValueSubject") {
    // 1
    var subscriptions = Set<AnyCancellable>()
    
    // 2
    let subject = CurrentValueSubject<Int, Never>(0)
    
    // 3
    subject
        .print()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions) // 4
    
    subject.send(1)
    subject.send(2)
    print("subject.value:\(subject.value)")
    subject.send(3)
    print("subject.value:\(subject.value)")
    
    subject
      .sink(receiveValue: { print("Second subscription:", $0) })
      .store(in: &subscriptions)

    subject.send(completion: .finished)
}

example(of: "Dynamically adjusting Demand") {
  final class IntSubscriber: Subscriber {
    typealias Input = Int
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
      subscription.request(.max(2))
    }
    
    func receive(_ input: Int) -> Subscribers.Demand {
      print("Received value", input)
      
      switch input {
      case 1:
        return .max(2) // 1
      case 3:
        return .max(1) // 2
      default:
        return .none // 3
      }
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
      print("Received completion", completion)
    }
  }
  
  let subscriber = IntSubscriber()
  
  let subject = PassthroughSubject<Int, Never>()
  
  subject.subscribe(subscriber)
  
  subject.send(1)
  subject.send(2)
  subject.send(3)
  subject.send(4)
  subject.send(5)
  subject.send(6)
}

example(of: "Type erasure") {
  // 1
  let subject = PassthroughSubject<Int, Never>()
  
  // 2
  let publisher = subject.eraseToAnyPublisher()
  
  // 3
  publisher
    .sink(receiveValue: { print($0) })
    .store(in: &subscriptions)
  
  // 4
  subject.send(0)
}



