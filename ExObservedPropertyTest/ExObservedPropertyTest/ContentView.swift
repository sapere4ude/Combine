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
        VStack(spacing: 30) {
            Button {
                self.contentViewModel.detailViewModel.requestRandomValue()
            } label: {
                Text("클릭하면 아래의 숫자가 업데이트 됩니다.")
            }
            Text(String(self.contentViewModel.detailViewModel.randomValue))
        }
    }
}

#Preview {
    ContentView(contentViewModel: ContentViewModel(detailViewModel: .init()))
}
