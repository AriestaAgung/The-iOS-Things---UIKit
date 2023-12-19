//
//  HomeCategoriesCell.swift
//  The iOS Things
//
//  Created by Ariesta APP on 19/12/23.
//

import UIKit

class HomeCategoriesCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    var isActive = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(active state: Bool) {
        switch state {
        case true:
            nameLabel.layer.addBorder(edge: .bottom, color: .black, thickness: 2)
        default:
            nameLabel.layer.borderWidth = 0
        }
        isActive = !isActive
    }

}
