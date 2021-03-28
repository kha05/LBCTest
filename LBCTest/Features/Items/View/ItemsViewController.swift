//
//  ItemsViewController.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation
import UIKit

final class ItemsViewController: UIViewController {
    private lazy var itemsCollectionView: UICollectionView = {
        let flowLayout = ItemsCollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = self.view.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        
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
        button.setImage(arrow.image, for: [])
        button.addTarget(self, action: .didTapToTop, for: .touchUpInside)
        return button
    }()
    
    private lazy var arrow: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "arrowUp")?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .white
        
        return imageView
    }()
    
    
    private let factory: ViewModelFactory
    private(set) lazy var viewModel: ItemsViewModelRepresentable = factory.makeItemsViewModel()
    
    private var scrollTop: Bool = true
    private lazy var arrowViewRightConstraint: NSLayoutConstraint = self.arrowButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 55)
    
    
    init(factory: ViewModelFactory) {
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        title = "Leboncoin"
        setup()
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        arrowButton.addSubview(arrow)
        view.addSubview(arrowButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            itemsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8.0),
            itemsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            itemsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            itemsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 50),
            arrowButton.heightAnchor.constraint(equalToConstant: 50),
            arrowButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            arrowViewRightConstraint,
            arrow.topAnchor.constraint(equalTo: arrowButton.topAnchor, constant: 16),
            arrow.leadingAnchor.constraint(equalTo: arrowButton.leadingAnchor, constant: 16),
            arrow.bottomAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: -16),
            arrow.trailingAnchor.constraint(equalTo: arrowButton.trailingAnchor, constant: -16)
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
        viewModel.reloadItems = { [weak self] in
            self?.itemsCollectionView.reloadData()
        }
    }
    
    func unbindViewModel() {
        viewModel.reloadItems = nil
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        bottomLoader.stopAnimating()
        bottomLoader.removeFromSuperview()
    }
}

extension ItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if viewModel.itemsNumber > 0  {
            return CGSize(width:(collectionView.frame.size.width), height: 100.0)
        }
        return CGSize.zero
    }
}


private extension Selector {
    static let didTapToTop = #selector(ItemsViewController.didTapToTop(_:))
}