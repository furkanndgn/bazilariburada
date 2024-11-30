//
//  MainScreenViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 23.11.2024.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!
    
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NSLayoutConstraint.activate([
            productTableView.topAnchor.constraint(equalTo: view.topAnchor),
            productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateUI() {
        if let products = viewModel.allProducts, !products.isEmpty {
            productTableView.reloadData()
        } else {
           // productTableView.isHidden = true
        }
    }
    
    private func setupView() {
        productTableView.dataSource = self
        productTableView.delegate = self
        //productTableView.isHidden = false
        
        let nib = UINib(nibName: "ProductCell", bundle: nil)
        productTableView.register(nib, forCellReuseIdentifier: "ProductCell")
        addSubscription()
    }
    
    private func addSubscription() {
        viewModel.$allProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &viewModel.cancellables)
    }
}


extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.productCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell
        else {
            return UITableViewCell()
        }
        
        let product = viewModel.product(by: indexPath.row)
        cell.config(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Implement the logic for opening the product detail screen
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
