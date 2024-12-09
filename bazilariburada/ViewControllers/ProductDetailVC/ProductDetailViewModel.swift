//
//  ProductDetailViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.12.2024.
//

import Foundation
import Combine

class ProductDetailViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var itemQuantity: Int = 1
}
