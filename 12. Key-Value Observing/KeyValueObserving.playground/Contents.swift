import Foundation
import Combine

let queue = OperationQueue()

//let subscription = queue.publisher(for: \.operationCount)
//  .sink {
//    print("Outstanding operations in queue: \($0)")
//  }

// 1
class TestObject: NSObject {
  // 2
  @objc dynamic var integerProperty: Int = 0
}

let obj = TestObject()

// 3
//let subscription = obj.publisher(for: \.integerProperty, options: [.prior])
//  .sink {
//    print("integerProperty changes to \($0)")
//  }

// 4
obj.integerProperty = 100
obj.integerProperty = 200


class MonitorObject: ObservableObject {
  @Published var someProperty = false
  @Published var someOtherProperty = ""
}

let object = MonitorObject()
let subscription = object.objectWillChange.sink {
  print("object will change")
}

object.someProperty = true
object.someOtherProperty = "Hello world"
