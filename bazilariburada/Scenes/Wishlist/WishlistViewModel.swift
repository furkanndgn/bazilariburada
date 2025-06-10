//
//  WishlistViewModel.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.06.2025.
//

import Foundation
import Combine

final class WishlistViewModel {

    private let wishlistService: WishlistServiceProtocol
    private let authenticationManager = AuthenticationManager.shared
    var cancellables = Set<AnyCancellable>()

    @Published private(set) var currentWishlist = [WishlistItem]()

    var productCount: Int {
        currentWishlist.count
    }

    init(wishlistService: WishlistServiceProtocol = WishlistService()) {
        self.wishlistService = wishlistService
        addSubscribers()
    }

    func wishlistItem(at index: Int) -> WishlistItem {
        return currentWishlist[index]
    }

    func getCurrentWishlist() async {
        await wishlistService.getUserWishlist(with: authenticationManager.accessToken ?? "")
    }

    func removeFromWishlist(_ id: String) async {
        await wishlistService.removeFromWishlist(productID: id, with: authenticationManager.accessToken ?? "")
    }
}


// MARK: - Setup bindings
private extension WishlistViewModel {

    func addSubscribers() {
        wishlistService.wishlistPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] wishlist in
                self?.currentWishlist = wishlist?.wishlist ?? []
            }
            .store(in: &cancellables)
    }
}
