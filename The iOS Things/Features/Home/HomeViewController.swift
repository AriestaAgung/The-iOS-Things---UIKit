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
    private var categoriesCollectionView: UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    private var scrollView: UIScrollView = UIScrollView()
    private var capsules: BulletIndicatorView?
    private let capsulesViewFrame = CGRect(origin: .zero, size: CGSize(width: 16, height: 24))
    private var categoriesAction: () -> Void = {}
    
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
        presenter.provideCategoriesData { cat in
            self.categoriesCollectionView.reloadData()
        }
        presenter.provideArticle { articles in }
    }
    
    private func setupUI() {
        self.title = "The iOS Things"
        
        setupScrollView()
        setupHeaderCollectionView()
        setupCapsuleIndicator()
        setupCategoriesCollectionView()
        
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    private func setupCategoriesCollectionView() {
        categoriesCollectionView.register(
            UINib(nibName: "HomeCategoriesCell", bundle: nil),
            forCellWithReuseIdentifier: "homeCategoriesCell"
        )
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        categoriesCollectionView.allowsMultipleSelection = false
        view.addSubview(categoriesCollectionView)
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoriesCollectionView.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 24),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
    }
    
    private func setupHeaderCollectionView() {
        headerCollectionView.register(
            UINib(nibName: "HomeHeaderCell", bundle: nil),
            forCellWithReuseIdentifier: "homeHeaderCell"
        )
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.contentInsetAdjustmentBehavior = .never
        headerCollectionView.insetsLayoutMarginsFromSafeArea = false
        self.view.addSubview(headerCollectionView)
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerCollectionView.heightAnchor.constraint(equalToConstant: headerHeights),
            headerCollectionView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            headerCollectionView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor)
        ])
        
    }
    
    private func setupCapsuleIndicator() {
        capsules?.removeFromSuperview()
        capsules = BulletIndicatorView(
            frame: capsulesViewFrame,
            totalCapsule: presenter.headArticles?.count ?? 4
        )
        if let capsules {
            self.view.addSubview(capsules)
            capsules.translatesAutoresizingMaskIntoConstraints = false
            capsules.setActiveCapsule(index: 0)
            NSLayoutConstraint.activate([
                capsules.heightAnchor.constraint(equalToConstant: 4),
                capsules.widthAnchor.constraint(equalToConstant: 100),
                capsules.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: -16),
                capsules.centerXAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.centerXAnchor)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        headerCollectionView.reloadData()
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return presenter.headArticles?.count ?? 0
        }
        return presenter.articleCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeHeaderCell", for: indexPath) as! HomeHeaderCell
            
            if let url = URL(string: presenter.headArticles?[indexPath.row].thumbnail ?? "") {
                cell.mainImage.kf.setImage(with: url)
            }
            
            cell.titleLabel.text = presenter.headArticles?[indexPath.row].title ?? ""
            cell.excerptLabel.text = presenter.headArticles?[indexPath.row].excerpt ?? ""
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCategoriesCell", for: indexPath) as! HomeCategoriesCell
        cell.nameLabel.text = presenter.articleCategories?[indexPath.row].rawValue ?? ""
        return cell
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            if let selected = collectionView.indexPathsForSelectedItems {
                for item in selected {
                    collectionView.deselectItem(at: item, animated: true)
                }
            }
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            return CGSize(width: self.view.frame.size.width, height: headerHeights)
        }
        
        return collectionView.contentSize
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            capsules?.setActiveCapsule(index: indexPath.row)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == categoriesCollectionView {
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
