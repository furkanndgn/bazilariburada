//
//  PaymentMethodsViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.06.2025.
//

import UIKit
import Combine

final class PaymentMethodsListingViewController: BaseViewController {

    private let viewModel: PaymentMethodsViewModel

    @IBOutlet weak var tableView: UITableView!

    private var cancellables = Set<AnyCancellable>()

    var selectedMethodChanged: Completion?

    init(_ viewModel: PaymentMethodsViewModel) {
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
    }

    @objc func pushAddScreen() {
        navigationController?
            .pushViewController(
                PaymentMethodsEditingViewController(viewModel),
                animated: true)
    }
}


// MARK: - Setup UI
private extension PaymentMethodsListingViewController {
    func setupView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddScreen))
        navigationItem.rightBarButtonItem = addButton
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardCell.getNib(), forCellReuseIdentifier: CardCell.identifier)
    }

    func addSubscribers() {
        viewModel.$paymentMethods
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    func updateUI() {
        tableView.reloadData()
        tableView.isHidden = viewModel.methodCount == 0
    }
}



// MARK: - TableView Delegation
extension PaymentMethodsListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.methodCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardCell.identifier, for: indexPath) as? CardCell else {
            return UITableViewCell()
        }
        let paymentMethod = viewModel.paymentMethod(at: indexPath.row)
        cell.configure(with: paymentMethod)
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let method = viewModel.paymentMethod(at: indexPath.row)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.delete(method)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let oldSelectedIndex = viewModel.paymentMethods.firstIndex(where: { $0.isSelected })
        viewModel.setSelected(at: indexPath.row)
        selectedMethodChanged?()
        var indexPathsToReload = [indexPath]
        if let old = oldSelectedIndex, old != indexPath.row {
            indexPathsToReload.append(IndexPath(row: old, section: 0))
        }
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
}
