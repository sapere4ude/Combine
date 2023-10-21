//
//  ContentView.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var contentViewModel: ContentViewModel
    
    init(contentViewModel: ContentViewModel) {
        self.contentViewModel = contentViewModel
    }
    
    var body: some View {
        VStack {
            Button {
                self.contentViewModel.detailViewModel.requestRandomValue()
            } label: {
                Text("test입니다")
            }

        }
    }
}

#Preview {
    ContentView(contentViewModel: ContentViewModel(detailViewModel: .init(text: "테스트입니다.")))
}
