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
    ㅖ
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
}


