import Combine
import SwiftUI
import PlaygroundSupport

let valuesPerSecond = 1.0
let delayInSeconds = 1.5

// 1
let sourcePublisher = PassthroughSubject<Date, Never>()

// 2
let delayedPublisher = sourcePublisher.delay(for: .seconds(delayInSeconds), scheduler: DispatchQueue.main)

// 3
let subscription = Timer
  .publish(every: 1.0 / valuesPerSecond, on: .main, in: .common) // 구독 조건
  .autoconnect() // 타이머를 사용한다면 autoconnect()를 사용해줘야 한다.
  .subscribe(sourcePublisher)

// 4
let sourceTimeline = TimelineView(title: "Emitted values (\(valuesPerSecond) per sec.):")

// 5
let delayedTimeline = TimelineView(title: "Delayed values (with a \(delayInSeconds)s delay):")

// 6
let view = VStack(spacing: 50) {
  sourceTimeline
  delayedTimeline
}

// 7
PlaygroundPage.current.liveView = UIHostingController(rootView: view.frame(width: 375, height: 600))

sourcePublisher.displayEvents(in: sourceTimeline)
delayedPublisher.displayEvents(in: delayedTimeline)
