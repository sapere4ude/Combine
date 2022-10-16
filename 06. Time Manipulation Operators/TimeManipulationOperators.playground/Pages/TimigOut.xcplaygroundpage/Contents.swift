//: [Previous](@previous)

import Combine
import SwiftUI
import PlaygroundSupport

enum TimeoutError: Error {
  case timedOut
}

let subject = PassthroughSubject<Void, TimeoutError>()

// 1
let timedOutSubject = subject.timeout(.seconds(5),
                                      scheduler: DispatchQueue.main,
                                      customError: { .timedOut })


let timeline = TimelineView(title: "Button taps")

let view = VStack(spacing: 100) {
  // 1
  Button(action: { subject.send() }) {
    Text("Press me within 5 seconds")
  }
  timeline
}

PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

timedOutSubject.displayEvents(in: timeline)



//: [Next](@next)
