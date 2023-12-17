//
//  HomeViewController.swift
//  The iOS Things
//
//  Created by Ariesta APP on 10/12/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var headerCollectionView: UICollectionView!
    private var capsules: BulletIndicatorView?
    private let capsulesViewFrame = CGRect(origin: .zero, size: CGSize(width: 16, height: 24))
    private let presenter = HomePresenter.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "The iOS Things"
        headerCollectionView.dataSource = self
        setupCapsuleIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.provideHeaderArticleData { articles in
            self.setupCapsuleIndicator()
        }
        presenter.provideCategoriesData { cat in }
        presenter.provideArticle { articles in }
    }
    
    private func setupCapsuleIndicator() {
        capsules?.removeFromSuperview()
        capsules = BulletIndicatorView(frame: capsulesViewFrame, totalCapsule: presenter.headArticles?.count ?? 4)
        if let capsules {
            
        self.view.addSubview(capsules)
        capsules.translatesAutoresizingMaskIntoConstraints = false
        capsules.setActiveCapsule(index: 0)
        NSLayoutConstraint.activate([
            capsules.heightAnchor.constraint(equalToConstant: 4),
            capsules.widthAnchor.constraint(equalToConstant: 100),
            capsules.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 16),
            capsules.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
        ])
        capsules.capsules.forEach { capsule in
            capsule.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addIndicatorGesture)))
        }
        }
    }

    @objc private func addIndicatorGesture(_ sender: UITapGestureRecognizer) {
        if let capsule = sender.view as? CapsuleView {
            self.capsules?.setActiveCapsule(index: capsule.tag)
        }
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.headArticles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
//        cell. = presenter.articles?[indexPath.row].title ?? ""
        return cell
    }
    
    
}
