//
//  ProductDetailViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 1.12.2024.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    @IBOutlet weak var productVoteCountLabel: UILabel!
    @IBOutlet weak var starRateView: StarRatingView!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    
    var product: Product
    
    init(product: Product) {
        self.product = product
        super.init(nibName: "ProductDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = product.name
        configureView(for: product)
    }
    
    private func configureView(for product: Product) {
        productImageView.image = UIImage(systemName: "bag.fill")
        productPriceLabel.text = product.price?.formatted(.currency(code: "USD"))
        productQuantityLabel.text = "\(product.quantity ?? 0) left"
        let reviewCount = product.reviews?.count ?? 0
        productVoteCountLabel.text = reviewCount == 1 ? "\(reviewCount) review" : "\(reviewCount) reviews"
        starRateView.rating = Float(product.averageRating ?? 0)
        productDescriptionLabel.text = product.description
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
