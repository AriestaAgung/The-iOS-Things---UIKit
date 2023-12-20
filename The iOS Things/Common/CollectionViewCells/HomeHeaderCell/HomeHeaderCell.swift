//
//  HomeHeaderCell.swift
//  The iOS Things
//
//  Created by Ariesta APP on 18/12/23.
//

import UIKit

class HomeHeaderCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var excerptLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    private var overlay = UIView()
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImage.contentMode = .scaleAspectFill
        excerptLabel.textColor = .white
        titleLabel.textColor = .white
        titleLabel.font = .boldSystemFont(ofSize: 24)
        self.mainView.insertSubview(overlay, at: 1)
        overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        overlay.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: mainView.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: mainView.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: mainView.trailingAnchor)
        ])
    }

}
