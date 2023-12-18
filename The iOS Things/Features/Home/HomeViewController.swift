//
//  HomeViewController.swift
//  The iOS Things
//
//  Created by Ariesta APP on 10/12/23.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    private let collectionPadding = 16.0
    private let presenter = HomePresenter.shared
    private var headerCollectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    private var capsules: BulletIndicatorView?
    private let capsulesViewFrame = CGRect(origin: .zero, size: CGSize(width: 16, height: 24))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.provideHeaderArticleData { articles in
            self.headerCollectionView.reloadData()
            self.setupCapsuleIndicator()
        }
        presenter.provideCategoriesData { cat in }
        presenter.provideArticle { articles in }
    }
    
    private func setupUI() {
        self.title = "The iOS Things"
        setupCollectionView()
        setupCapsuleIndicator()
    }
    
    private func setupCollectionView() {
        headerCollectionView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "homeHeaderCell")
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        self.view.addSubview(headerCollectionView)
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerCollectionView.heightAnchor.constraint(equalToConstant: 200),
            headerCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            headerCollectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
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
                capsules.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: -16),
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
            let index = IndexPath(row: capsule.tag, section: 0)
            self.headerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.headArticles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeHeaderCell", for: indexPath) as! HomeHeaderCell
        
        if let url = URL(string: presenter.headArticles?[indexPath.row].thumbnail ?? "") {
            cell.mainImage.kf.setImage(with: url)
        }
        
        cell.titleLabel.text = presenter.headArticles?[indexPath.row].title ?? ""
        cell.excerptLabel.text = presenter.headArticles?[indexPath.row].excerpt ?? ""
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        capsules?.setActiveCapsule(index: indexPath.row)
    }
}
