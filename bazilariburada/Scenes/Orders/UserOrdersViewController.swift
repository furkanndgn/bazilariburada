//
//  UserOrdersViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 27.06.2025.
//

import UIKit
import Combine

final class UserOrdersViewController: BaseViewController {

    private let viewModel: UserOrdersViewModel

    @IBOutlet weak var tableView: UITableView!

    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            await viewModel.getUserOrders()
        }
        setupView()
        addSubscribers()
    }

    init(_ viewModel: UserOrdersViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


private extension UserOrdersViewController {

    func setupView() {
        title = "My Orders"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(OrderCell.getNib(), forCellReuseIdentifier: OrderCell.identifier)
    }

    func updateUI() {
        if viewModel.orderCount == 0 {
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            tableView.isHidden = false
        }
    }

    func addSubscribers() {
        viewModel.$userOrders
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &cancellables)
    }
}


extension UserOrdersViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orderCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderCell.identifier) as? OrderCell else {
            return UITableViewCell()
        }
        let order = viewModel.order(at: indexPath.row)
        cell.configure(with: order)
        return cell
    }
}
