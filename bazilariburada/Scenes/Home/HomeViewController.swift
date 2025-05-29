//
//  HomeViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import UIKit
import Combine

final class HomeViewController: BaseViewController, RouteEmitting {

    var onRoute: ((Route) -> Void)?
    let viewModel: HomeViewModel

    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var productCollectionView: UICollectionView!

    init(_ viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        Task {
            await viewModel.getProducts()
        }
    }
}


// MARK: - Setup UI
private extension HomeViewController {
    func updateUI() {
        if let products = viewModel.allProducts, !products.isEmpty {
            productCollectionView.reloadData()
            productCollectionView.isHidden = false
        } else {
            productCollectionView.isHidden = true
        }
    }

    func setupView() {
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        self.title = Constants.Text.Title.mainApp
        self.navigationItem.backButtonTitle = ""
        let nib = ProductCell.getNib()
        productCollectionView.register(nib, forCellWithReuseIdentifier: ProductCell.identifier)
        addSubscribers()
    }

    func addSubscribers() {
        viewModel.$allProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)

    }
}


extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productCount ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProductCell.identifier,
            for: indexPath
        ) as? ProductCell else {
            return UICollectionViewCell()
        }
        let product = viewModel.product(by: indexPath.row)
        cell.configure(with: product)
        cell.onTap = { [weak self] id in
            cell.setLoading(true)
            Task {
                await self?.viewModel.addToCart(by: id)
            }
            self?.viewModel.onCartUpdate = {
                cell.setLoading(false)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let product = viewModel.product(by: indexPath.row)
        self.onRoute?(.toProductDetail(self, product))
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 172, height: 248)
    }
}

extension HomeViewController {
    enum Route {
        case toProductDetail(BaseViewController, Product)
    }
}
