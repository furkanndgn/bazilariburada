//
//  ProductReviewsViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 3.12.2024.
//

import UIKit

class ProductReviewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    let viewModel = ReviewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "ProductReviewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProductReviewCell")
    }
    
    private func addSubscription() {
        viewModel.$allReviews
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateUI()
            }
            .store(in: &viewModel.cancellables)
    }
    
    private func updateUI() {
        if let reviews = viewModel.allReviews, !reviews.isEmpty {
            tableView.reloadData()
            tableView.isHidden = false
        }
        else {
            tableView.isHidden = true
        }
    }
}

extension ProductReviewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reviewCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as? ProductReviewCell
        else {
            return UITableViewCell()
        }
        
        let review = viewModel.review(by: indexPath.row)
        cell.configure(for: review)
        return cell
    }
}
