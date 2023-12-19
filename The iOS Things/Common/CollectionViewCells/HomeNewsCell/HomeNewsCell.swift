//
//  HomeNewsCell.swift
//  The iOS Things
//
//  Created by Ariesta APP on 19/12/23.
//

import UIKit

class HomeNewsCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var bookmarkIcon: UIImageView!
    @IBOutlet weak var categoryBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryBackground.backgroundColor = ArticleCategory(rawValue: categoryLabel.text ?? "")?
            .getBGColor()
        categoryBackground.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
