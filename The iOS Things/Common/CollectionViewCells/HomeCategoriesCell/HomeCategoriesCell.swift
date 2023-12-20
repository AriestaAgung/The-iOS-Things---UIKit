//
//  HomeCategoriesCell.swift
//  The iOS Things
//
//  Created by Ariesta APP on 19/12/23.
//

import UIKit

class HomeCategoriesCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                nameLabel.layer.addBorder(edge: .bottom, color: .black, thickness: 2)
                nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
                nameLabel.textColor = .black
            } else {
                nameLabel.layer.sublayers?.forEach { layer in
                    if layer.name == "borderLayer" {
                        layer.removeFromSuperlayer()
                    }
                }
                nameLabel.font = .systemFont(ofSize: 17, weight: .regular)
                nameLabel.textColor = .lightGray
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.numberOfLines = 2
        
    }
    
    func set(active state: Bool) {
        switch state {
        case true:
            nameLabel.layer.addBorder(edge: .bottom, color: .black, thickness: 2)
        default:
            nameLabel.layer.borderWidth = 0
        }
        
    }

}
