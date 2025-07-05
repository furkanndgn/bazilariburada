//
//  UIImageView+Ext.swift
//  bazilariburada
//
//  Created by Furkan Doğan on 19.06.2025.
//

import UIKit

extension UIImageView {
    func load(url: URL, completion: Completion? = nil) {
        addLoadingView()

        DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        self.removeLoadingView()
                        completion?()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.removeLoadingView()
                        completion?()
                    }
                }
            }
        }
    }


private extension UIImageView {
    func addLoadingView() {
        let loadingView = LoadingView()
        loadingView.tag = Constants.UI.loadingViewImageTag
        self.addSubview(loadingView)
        loadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    func removeLoadingView() {
        subviews.filter { $0.tag == Constants.UI.loadingViewImageTag }.forEach { $0.removeFromSuperview() }
    }
}
