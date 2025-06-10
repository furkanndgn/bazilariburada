//
//  CartViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 9.12.2024.
//

import UIKit
import Combine

final class CartViewController: BaseViewController, RouteEmitting {

    private let viewModel: CartViewModel
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totalPriceContainer: UIView!
    @IBOutlet weak var dummyCheckoutButton: UIButton!

    var onRoute: ((Route) -> Void)?

    init(_ viewModel: CartViewModel) {
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
            await viewModel.getCurrentCart()
        }
    }

    @IBAction func checkoutTapped(_ sender: Any) {
        let vc = CheckoutViewController(CheckoutViewModel(totalPrice: viewModel.totalPrice))
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [
                .medium(), // About 50% of the screen
                .large()   // Full screen
            ]
            sheet.prefersGrabberVisible = true // Shows the draggable bar
            sheet.selectedDetentIdentifier = .medium // Start at medium
        }

        vc.modalPresentationStyle = .pageSheet // Important!
        present(vc, animated: true)
    }
}


// MARK: - Setup UI
private extension CartViewController {
    func setupView() {
#warning("FIXME: title logic")
        title = "My Cart"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CartCell.getNib(), forCellReuseIdentifier: CartCell.identifier)
        configureCheckoutStack()
    }

    func configureCheckoutStack() {
        checkoutButton.layer.cornerRadius = 12
        checkoutButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        dummyCheckoutButton.layer.cornerRadius = 12
        dummyCheckoutButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        totalPriceContainer.layer.cornerRadius = 12
        totalPriceContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        totalPriceContainer.layer.borderColor = UIColor.Colors.green100.cgColor
        totalPriceContainer.layer.borderWidth = 1
    }

    func updateUI() {
        totalPriceLabel.text = "Total: \(viewModel.totalPrice.asCurrency(locale: Locale(identifier: "en_US")) ?? "0")"
        if !viewModel.cartDisplayItems.isEmpty {
            tableView.reloadData()
            tableView.isHidden = false
            checkoutButton.alpha = 1
            dummyCheckoutButton.isHidden = true
            totalPriceContainer.layer.borderColor = UIColor.Colors.green100.cgColor
        } else {
            totalPriceContainer.layer.borderColor = UIColor.tertiarySystemFill.cgColor
            checkoutButton.alpha = 0
            dummyCheckoutButton.isHidden = false
            tableView.isHidden = true
        }
    }

    func addSubscribers() {
        viewModel.$cartDisplayItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
}


// MARK: - TableViewDelegation
extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.productCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartCell.identifier, for: indexPath) as? CartCell else {
            return UITableViewCell()
        }
        let product = viewModel.product(at: indexPath.row)
        cell.configure(with: product)
        cell.onQuantityChange = { [weak self] quantity in
            Task {
                await self?.viewModel.updateItemQuantity(product.id, quantity: quantity)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let product = viewModel.product(at: indexPath.row)
        self.onRoute?(.toProductDetail(self, product.product))
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let product = viewModel.product(at: indexPath.row)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            Task {
                await self?.viewModel.removeItemFromCart(product.id)
            }
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}


// MARK: - Setup Routing
extension CartViewController {
    enum Route {
        case toProductDetail(BaseViewController, Product)
    }
}
