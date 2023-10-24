//
//  DetailViewModel.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import Combine
import UIKit

final class DetailViewModel: ObservableObject {
    
    @Published var randomValue = Int.random(in: 1...100)
    
    func requestRandomValue() -> Int {
        randomValue = Int.random(in: 1...100)
        print("\(randomValue)")
        return randomValue
    }
}
