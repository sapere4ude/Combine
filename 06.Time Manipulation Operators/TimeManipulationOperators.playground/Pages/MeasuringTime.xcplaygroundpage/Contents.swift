//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport

let subject = PassthroughSubject<String, Never>()

// 1
let measureSubject = subject.measureInterval(using: DispatchQueue.main)

let subjectTimeline = TimelineView(title: "Emitted values")
let measureTimeline = TimelineView(title: "Measured values")

let view = VStack(spacing: 100) {
  subjectTimeline
  measureTimeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

subject.displayEvents(in: subjectTimeline)
measureSubject.displayEvents(in: measureTimeline)

let subscription1 = subject.sink {
  print("+\(deltaTime)s: Subject emitted: \($0)")
}

let subscription2 = measureSubject.sink {
  print("+\(deltaTime)s: Measure emitted: \($0)")
}

subject.feed(with: typingHelloWorld)


//: [Next](@next)
