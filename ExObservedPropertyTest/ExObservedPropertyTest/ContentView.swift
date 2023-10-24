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
                Text("버튼을 눌러주세요")
            }
            Text(String(self.contentViewModel.detailViewModel.randomValue))
        }
    }
}

#Preview {
    ContentView(contentViewModel: ContentViewModel(detailViewModel: .init()))
}
