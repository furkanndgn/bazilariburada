//
//  HomeViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import UIKit
import Combine

final class HomeViewController: UIViewController, RouteEmitting {

    var onRoute: ((Route) -> Void)?
    let viewModel: HomeViewModel

    @IBOutlet weak var productTableView: UITableView!

    init(_ viewModel: HomeViewModel = HomeViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    
    private func updateUI() {
        if let products = viewModel.allProducts, !products.isEmpty {
            productTableView.reloadData()
            productTableView.isHidden = false
        } else {
           productTableView.isHidden = true
        }
    }

    private func setupView() {
        productTableView.dataSource = self
        productTableView.delegate = self
        self.title = Constants.String.Title.app
        self.navigationItem.backButtonTitle = Constants.String.empty
        let nib = ProductCell.getNib()
        productTableView.register(nib, forCellReuseIdentifier: ProductCell.identifier)
        addSubscribers()
    }
    
    private func addSubscribers() {
        viewModel.$allProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &viewModel.cancellables)
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductCell.identifier,
            for: indexPath
        ) as? ProductCell
        else {
            return UITableViewCell()
        }
        let product = viewModel.product(by: indexPath.row)
        cell.configure(with: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = viewModel.product(by: indexPath.row)
        self.onRoute?(.toProductDetail(self, product))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension HomeViewController {
    enum Route {
        case toProductDetail(UIViewController, Product)
    }
}
