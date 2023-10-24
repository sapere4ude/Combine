//
//  ContentViewModel.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    
    var detailViewModel: DetailViewModel // 처음 가졌던 생각은 여기에 그냥 @Published 붙이면 업데이트 되는거 아닌가? 라는 생각
    private var cancellables: Set<AnyCancellable>
    
    init(detailViewModel: DetailViewModel) {
        
        self.detailViewModel = detailViewModel
        cancellables = .init()
        
        bind()
    }
    
    private func bind() {
        
        detailViewModel
            .$randomValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
