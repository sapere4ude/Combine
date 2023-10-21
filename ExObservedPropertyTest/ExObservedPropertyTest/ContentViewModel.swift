//
//  ContentViewModel.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import Combine
import SwiftUI

final class ContentViewModel: ObservableObject {
    
    var detailViewModel: DetailViewModel
    
    init(detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
    }
}
