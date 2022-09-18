import UIKit
import Combine

example(of: "publsiher <-> subscriber 정리") {
    // publisher 생성
    let publisherJust = Just("Kant")
    
    // subscribe 방식
    publisherJust.subscribe(KantSubscriber())
    
    class KantSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = Never
        
        // 1. subscriber에게 publisher를 성공적으로 구독했음을 알리고 item을 요청하는 단계
        func receive(subscription: Subscription) {
            print("receive(subscription: Subscription)")
            subscription.request(.unlimited)
        }
        
        // 2. subscriber에게 publisher가 element를 생성했음을 알림
        func receive(_ input: String) -> Subscribers.Demand {
            print("receive(_ input: String) -> Subscribers.Demand")
            return .none
        }
        
        // 3. publisher에게 publisher가 정상적으로 혹은 오류로 publish를 완료했음을 알림
        func receive(completion: Subscribers.Completion<Never>) {
            print("receive(completion: Subscribers.Completion<Never>)")
        }
    }
    
    // sink 방식
    let subscriber = publisherJust.sink(receiveCompletion: { (result) in
        switch result {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }, receiveValue: { (value) in
        print(value)
    })
    
    // assign 방식
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

example(of: "PassthroughSubject & CurrentValueSubject") {
    
    let passthroughSubject = PassthroughSubject<String, Never>()
    
    let subscriber1 = passthroughSubject.sink(receiveCompletion: { (result) in
        switch result {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }, receiveValue: { value in
        print(value)
    })
    
    let subscriber2 = passthroughSubject.sink(receiveCompletion: { (result) in
        switch result {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error.localizedDescription)
        }
    }, receiveValue: { value in
        print(value)
    })
    
    passthroughSubject.send("good morning!")
    passthroughSubject.send("kant")
    passthroughSubject.send(completion: .finished)
    passthroughSubject.send(".finished 되었기때문에 해당 내용은 출력될 수 없음")
    
    let currentValueSubject = CurrentValueSubject<String, Never>("Kant")
    let subscriber = currentValueSubject.sink(receiveValue: {
        print($0)
    })
    currentValueSubject.value = "currentValueSubject 확인중"
    currentValueSubject.send("good morning!")
}
