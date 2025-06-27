//
//  ReviewAddingViewController.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 19.06.2025.
//

import UIKit

final class ReviewAddingViewController: BaseViewController {

    private let viewModel: ReviewsViewModel

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var starRatingView: InteractableStarRatingView!
    @IBOutlet weak var reviewTextField: UITextField!

    init(_ viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        Task {
            await viewModel
                .addReview(comment: reviewTextField.text ?? "", rating: Int(starRatingView.rating)) { [weak self] response in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @IBAction func reviewChanged(_ sender: Any) {
        if let review = reviewTextField.text, !review.isEmpty {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
}
