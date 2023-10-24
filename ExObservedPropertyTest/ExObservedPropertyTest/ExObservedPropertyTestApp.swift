//
//  ExObservedPropertyTestApp.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import SwiftUI

@main
struct ExObservedPropertyTestApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(contentViewModel: ContentViewModel(detailViewModel: .init()))
        }
    }
}
