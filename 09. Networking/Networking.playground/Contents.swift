import Combine
import Foundation

let url = URL(string: "https://www.raywenderlich.com")!

let publisher = URLSession.shared
// 1
  .dataTaskPublisher(for: url)  // 결과값을 data 형식으로 반환해주는 것이 있음.
  .map(\.data)                  // 그래서 여기서 map 을 사용해서 data를 모아주는 것
  .multicast { PassthroughSubject<Data, URLError>() }   // 챕터13. resource management 다시 다룰 예정

// 2
let subscription1 = publisher
  .sink(receiveCompletion: { completion in
    if case .failure(let err) = completion {
      print("Sink1 Retrieving data failed with error \(err)")
    }
  }, receiveValue: { object in
    print("Sink1 Retrieved object \(object)")
  })

// 3
let subscription2 = publisher
  .sink(receiveCompletion: { completion in
    if case .failure(let err) = completion {
      print("Sink2 Retrieving data failed with error \(err)")
    }
  }, receiveValue: { object in
    print("Sink2 Retrieved object \(object)")
  })

// 4
let subscription = publisher.connect()


