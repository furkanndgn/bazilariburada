//
//  AddressListingViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 8.06.2025.
//

import UIKit
import Combine

final class AddressListingViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!

    private let viewModel: AddressViewModel
    private var cancellables = Set<AnyCancellable>()

    var selectedAddressChanged: Completion?

    init(_ viewModel: AddressViewModel) {
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
        navigationController?.pushViewController(AddressEditingViewController(viewModel, config: .add), animated: true)
    }
}


// MARK: - Setup UI
private extension AddressListingViewController {
    
    func setupView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushAddScreen))
        navigationItem.rightBarButtonItem = addButton
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AddressCell.getNib(), forCellReuseIdentifier: AddressCell.identifier)
    }

    func addSubscribers() {
        viewModel.$addresses
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }

    func updateUI() {
        tableView.reloadData()
        tableView.isHidden = viewModel.addressCount == 0
    }
}


// MARK: - TableView Delegation
extension AddressListingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.addressCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddressCell.identifier) as? AddressCell else {
            return UITableViewCell()
        }
        let address = viewModel.address(at: indexPath.row)
        cell.configure(with: address)
        cell.editTapped = { [weak self] in
            guard let self else { return }
            self.viewModel.addressToEdit = address
            self.navigationController?
                .pushViewController(AddressEditingViewController(self.viewModel, config: .update), animated: true)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let address = viewModel.address(at: indexPath.row)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.viewModel.delete(address)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            if address.isSelected {
                self?.selectedAddressChanged?()
            }
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let oldSelectedIndex = viewModel.addresses.firstIndex(where: { $0.isSelected })
        viewModel.setSelected(at: indexPath.row)
        selectedAddressChanged?()
        var indexPathsToLoad = [indexPath]
        if let old = oldSelectedIndex, old != indexPath.row {
            indexPathsToLoad.append(IndexPath(row: old, section: 0))
        }
        tableView.reloadRows(at: indexPathsToLoad, with: .automatic)
    }

}
