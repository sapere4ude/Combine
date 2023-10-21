//
//  DetailViewModel.swift
//  ExObservedPropertyTest
//
//  Created by Kant on 10/21/23.
//

import Combine
import UIKit

final class DetailViewModel: ObservableObject {
    
    @Published var text: String
    @Published var randomValue = Int.random(in: 1...100)
    // TODO: - 랜덤인지 아닌지 판별하는 Flag 만들기
    
    init(text: String) {
        self.text = text
    }
    
    static let mock = DetailViewModel(text: "z.z")
    
    func requestRandomValue() -> Int {
        randomValue = Int.random(in: 1...100)
        return randomValue
    }
}
