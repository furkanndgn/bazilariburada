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
    
    init(product: Product) {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func configureView(for product: Product) {
        productImageView.image = UIImage(systemName: "bag.fill")
        productPriceLabel.text = product.price?.formatted(.currency(code: "USD"))
        productQuantityLabel.text = "\(product.quantity ?? 0) left."
        productVoteCountLabel.text = "\(product.reviews?.count ?? 0)"
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
