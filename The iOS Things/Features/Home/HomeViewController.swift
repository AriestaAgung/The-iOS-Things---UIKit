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
    private lazy var newsTableView = UITableView(frame: .zero, style: .plain)
    private var scrollView: UIScrollView = UIScrollView()
    private var capsules: BulletIndicatorView?
    private let capsulesViewFrame = CGRect(origin: .zero, size: CGSize(width: 16, height: 24))
    private var categoriesAction: () -> Void = {}
    private var scrollContentView = UIView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.provideHeaderArticleData { articles in
            self.headerCollectionView.reloadData()
            self.setupScrollView()
            self.setupCapsuleIndicator()
        }
        presenter.provideCategoriesData { cat in
            self.categoriesCollectionView.reloadData()
        }
        presenter.provideArticle { articles in
            self.newsTableView.reloadData()
            self.setupNewsTableView()

        }
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
        self.scrollView.addSubview(scrollContentView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.scrollView.heightAnchor.constraint(
                equalToConstant: scrollContentView.frame.size.height
            ),
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: 0),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
//            scrollContentView.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor)
        ])
    }
    private func setupNewsTableView() {
        newsTableView.register(
            UINib(nibName: "HomeNewsCell", bundle: nil),
            forCellReuseIdentifier: "homeNewsCell"
        )
        newsTableView.dataSource = self
        newsTableView.delegate = self
        newsTableView.isScrollEnabled = false
        newsTableView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        scrollContentView.addSubview(newsTableView)
        
        newsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsTableView.heightAnchor.constraint(equalToConstant: CGFloat(presenter.articles?.count ?? 0) * articleCellHeight),
            newsTableView.topAnchor.constraint(equalTo: categoriesCollectionView.bottomAnchor),
            newsTableView.bottomAnchor.constraint(equalTo: self.scrollContentView.bottomAnchor, constant: 0),
            newsTableView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor),
            newsTableView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor)
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
        scrollContentView.addSubview(categoriesCollectionView)
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoriesCollectionView.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: 24),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor),
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
        scrollContentView.addSubview(headerCollectionView)
        headerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerCollectionView.heightAnchor.constraint(equalToConstant: headerHeights),
            headerCollectionView.topAnchor.constraint(equalTo: self.scrollContentView.topAnchor),
            headerCollectionView.leadingAnchor.constraint(equalTo: self.scrollContentView.leadingAnchor),
            headerCollectionView.trailingAnchor.constraint(equalTo: self.scrollContentView.trailingAnchor)
        ])
        
        headerCollectionView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupCapsuleIndicator() {
        capsules?.removeFromSuperview()
        capsules = BulletIndicatorView(
            frame: capsulesViewFrame,
            totalCapsule: presenter.headArticles?.count ?? 4
        )
        if let capsules {
            self.scrollContentView.addSubview(capsules)
            capsules.translatesAutoresizingMaskIntoConstraints = false
            capsules.setActiveCapsule(index: 0)
            NSLayoutConstraint.activate([
                capsules.heightAnchor.constraint(equalToConstant: 4),
                capsules.widthAnchor.constraint(equalToConstant: 100),
                capsules.topAnchor.constraint(equalTo: headerCollectionView.bottomAnchor, constant: -16),
                capsules.centerXAnchor.constraint(equalTo: self.scrollContentView.safeAreaLayoutGuide.centerXAnchor)
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
        categoriesCollectionView.reloadData()
        newsTableView.reloadData()
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
            presenter.provideArticle(for: presenter.articleCategories?[indexPath.row] ?? .For_You, completion: { articles in
                self.newsTableView.reloadData()
                let firstArticleFrameHeight = self.newsTableView.frame.size.height
                self.newsTableView.frame.size.height = CGFloat(Double(articles.count) * articleCellHeight)
                self.scrollContentView.frame.size.height = self.scrollContentView.frame.size.height - (firstArticleFrameHeight - self.newsTableView.frame.size.height)
                self.scrollView.contentSize.height = self.scrollContentView.frame.height
            })
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            return CGSize(width: collectionView.frame.size.width, height: headerHeights)
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

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeNewsCell") as! HomeNewsCell
        let article = presenter.articles?[indexPath.row]
        if let url = URL(string: article?.thumbnail ?? "") {
            cell.thumbnail.kf.setImage(with: url)
        }
        cell.titleLabel.text = article?.title
        cell.authorLabel.text = article?.publisher
        cell.categoryLabel.text = article?.category?.rawValue
        cell.categoryLabel.textColor = article?.category?.getFontColor()
        cell.categoryBackground.backgroundColor = article?.category?.getBGColor()
        cell.categoryBackground.layer.cornerRadius = 4
        
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return articleCellHeight
    }
}
