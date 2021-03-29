//
//  ItemsViewController.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation
import UIKit

final class ItemsViewController: UIViewController {
    private lazy var loader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            activityIndicator.style = .large
        } else {
            activityIndicator.style = .gray
        }
        
        activityIndicator.layer.cornerRadius = 8
        activityIndicator.layer.opacity = 0.7
        return activityIndicator
    }()
            
    private lazy var itemsCollectionView: UICollectionView = {
        let flowLayout = ItemsCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = view.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.isPrefetchingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: ItemCollectionViewCell.self))
        collectionView.accessibilityIdentifier = "ItemsViewController_ItemsCollectionView"
        return collectionView
    }()
    
    private lazy var bottomLoader: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.style = .gray
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.tintColor = UIColor.gray
        return loading
    }()
    
    private lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor.orange
        button.layer.borderWidth = 1.5
        button.layer.borderColor = UIColor.white.cgColor
        button.setImage(UIImage(named: "arrowUp"), for: [])
        button.contentMode = .center
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.addTarget(self, action: .didTapToTop, for: .touchUpInside)
        return button
    }()

    private let viewModel: ItemsViewModelRepresentable
    
    private let arrowViewVisibleBottomConstant: CGFloat = -12
    private let arrowViewHiddentBottomConstant: CGFloat = 55
    private let scrollOffsetY: CGFloat = 10
    private lazy var arrowViewRightConstraint: NSLayoutConstraint = self.arrowButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: arrowViewHiddentBottomConstant)
    
    
    init(viewModel: ItemsViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Leboncoin"
        setup()
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.startAnimating()
        viewModel.synchronize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        unbindViewModel()
    }
}
// MARK: Setup interface
private extension ItemsViewController {
    func setup() {
        setupInterface()
        setupConstraints()
    }
    
    func setupInterface() {
        view.backgroundColor = .white
        view.addSubview(itemsCollectionView)
        view.addSubview(arrowButton)
        view.addSubview(loader)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            itemsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            itemsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            itemsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            itemsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 50),
            arrowButton.heightAnchor.constraint(equalToConstant: 50),
            arrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            arrowViewRightConstraint
        ])
    }
    
    @objc
    func didTapToTop(_ sender: UITapGestureRecognizer) {
        let topOffest = CGPoint(x: 0, y: -(self.itemsCollectionView.contentInset.top))
        self.itemsCollectionView.setContentOffset(topOffest, animated: true)
    }
}

// MARK: Bindings
extension ItemsViewController {
    func bindViewModel() {
        viewModel.reloadItems = { [itemsCollectionView, loader] in
            loader.stopAnimating()
            itemsCollectionView.reloadData()
        }
        
        viewModel.stopLoader = { [loader] in
            loader.stopAnimating()
        }
    }
    
    func unbindViewModel() {
        viewModel.reloadItems = nil
        viewModel.stopLoader = nil
    }
}

// MARK: Delegate
extension ItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ItemCollectionViewCell.self), for: indexPath) as? ItemCollectionViewCell else { fatalError("Failed to dequeue a cell with identifier \(String(describing: ItemCollectionViewCell.self))") }
        
        cell.configure(with: viewModel, at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.tapItem(at: indexPath)
    }
}

extension ItemsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.prefetchNextItemsImages(at: indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        viewModel.cancelPrefetchNextItemsImages(at: indexPaths)
    }
}

extension ItemsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollOffsetY {
            arrowViewRightConstraint.constant = arrowViewVisibleBottomConstant
        } else {
            arrowViewRightConstraint.constant = arrowViewHiddentBottomConstant
        }
    }
}

private extension Selector {
    static let didTapToTop = #selector(ItemsViewController.didTapToTop(_:))
}
