//
//  HomeViewController.swift
//  The iOS Things
//
//  Created by Ariesta APP on 10/12/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var headerCollectionView: UICollectionView!
    private var capsules: BulletIndicatorView!
    private let capsulesViewFrame = CGRect(origin: .zero, size: CGSize(width: 16, height: 24))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The iOS Things"
        capsules = BulletIndicatorView(frame: capsulesViewFrame, totalCapsule: 4)
        
        self.view.addSubview(capsules)
        capsules.translatesAutoresizingMaskIntoConstraints = false
        capsules.setActiveCapsule(index: 1)
        NSLayoutConstraint.activate([
            capsules.heightAnchor.constraint(equalToConstant: 4),
            capsules.widthAnchor.constraint(equalToConstant: 100),
            capsules.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 16),
            capsules.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }


}
