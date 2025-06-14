//
//  WishlistViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 10.06.2025.
//

import UIKit
import Combine

final class WishlistViewController: BaseViewController, RouteEmitting {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: WishlistViewModel
    private var cancellables = Set<AnyCancellable>()
    var onRoute: ((Route) -> Void)?

    init(_ viewModel: WishlistViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubscribers()
        Task {
            await viewModel.getCurrentWishlist()
        }
    }
}


// MARK: - Setup UI
private extension WishlistViewController {

    func setupView() {
        title = "Favorites"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(WishlistCell.getNib(), forCellReuseIdentifier: WishlistCell.identifier)
    }

    func addSubscribers() {
        viewModel.$currentWishlist
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    func updateUI() {
        if !viewModel.currentWishlist.isEmpty {
            tableView.reloadData()
            tableView.isHidden = false
        } else {
            tableView.isHidden = true
        }
    }
}


// MARK: - TableView Delegation
extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WishlistCell.identifier, for: indexPath) as? WishlistCell else {
            return UITableViewCell()
        }

        let item = viewModel.wishlistItem(at: indexPath.row)
        cell.configure(with: item)
        cell.onTap = { [weak self] id in
            cell.setLoading(true)
            Task {
                await self?.viewModel.addItemToCart(id)
            }
            self?.viewModel.onAddToCart = {
                cell.setLoading(false)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = viewModel.wishlistItem(at: indexPath.row)
        Task {
            let productDetail = await viewModel.getProductDetail(product.id)
            guard let productDetail else { return }
            self.onRoute?(.toProductDetail(self, productDetail))
        }
    }

}


// MARK: - SetupRouting
extension WishlistViewController {
    internal enum Route {
        case toProductDetail(BaseViewController, Product)
    }
}
