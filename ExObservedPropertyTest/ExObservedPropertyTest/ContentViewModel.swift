//
//  ContentViewModel.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import SwiftUI
import Combine

final class ContentViewModel: ObservableObject {
    
    var detailViewModel: DetailViewModel
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
