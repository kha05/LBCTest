//
//  ItemsCollectionViewCell.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation
import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    private lazy var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.accessibilityIdentifier = "ItemCollectionViewCell_Loader"
        return indicator
    }()
    
    private lazy var urgentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.systemOrange
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = true
        view.accessibilityIdentifier = "ItemCollectionViewCell_MarkContainer"
        return view
    }()
    
    private lazy var urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Urgent"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.accessibilityIdentifier = "ItemCollectionViewCell_UrgentLabel"
        return label
    }()
    
    private lazy var itemImage: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.isOpaque = true
        imageView.backgroundColor = backgroundColor
        imageView.accessibilityIdentifier = "ItemCollectionViewCell_ImageView"
        return imageView
    }()
    
    private lazy var titleItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = contentView.backgroundColor
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.accessibilityIdentifier = "ItemCollectionViewCell_TitleItemLabel"
        return label
    }()
    
    private lazy var categoryItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = contentView.backgroundColor
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.accessibilityIdentifier = "ItemCollectionViewCell_TitleItemLabel"
        return label
    }()
    
    private lazy var priceItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = contentView.backgroundColor
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.accessibilityIdentifier = "ItemCollectionViewCell_PriceItemLabel"
        return label
    }()
    
    private var index: IndexPath?
    private var viewModel: ItemsViewModelRepresentable?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImage.image = nil
        titleItemLabel.text = ""
        categoryItemLabel.text = ""
        priceItemLabel.text = ""
        
        if let currentIndex = index {
            viewModel?.cancelPrefetchNextItemsImages(at: [currentIndex])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with viewModel: ItemsViewModelRepresentable, at index: IndexPath) {
        self.viewModel = viewModel
        self.index = index
        titleItemLabel.text = viewModel.itemTitle(at: index)
        categoryItemLabel.text = viewModel.itemCategory(at: index)
        priceItemLabel.text = viewModel.itemPrice(at: index)
        urgentContainer.isHidden = !viewModel.isUrgentItem(at: index)
        viewModel.itemImage(at: index) { [loader, itemImage] (image) in
            loader.stopAnimating()
            itemImage.image = image
        }
    }
    
}

private extension ItemCollectionViewCell {
    func setup() {
        setupInterface()
        setupConstraints()
    }
    
    func setupInterface() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 6
        contentView.layer.borderWidth = 0.2
        contentView.layer.borderColor = UIColor.gray.cgColor
        contentView.layer.masksToBounds = true
        alpha = 1.0
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        
        contentView.addSubview(itemImage)
        urgentContainer.addSubview(urgentLabel)
        contentView.addSubview(urgentContainer)
        contentView.addSubview(titleItemLabel)
        contentView.addSubview(categoryItemLabel)
        contentView.addSubview(priceItemLabel)
        contentView.addSubview(loader)
        
        
    }
    
    func setupConstraints() {
        titleItemLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        priceItemLabel.setContentHuggingPriority(.required, for: .vertical)
        categoryItemLabel.setContentHuggingPriority(.required, for: .vertical)
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: itemImage.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: itemImage.centerYAnchor),
            
            itemImage.heightAnchor.constraint(equalToConstant: 100),
            itemImage.widthAnchor.constraint(equalTo: itemImage.heightAnchor),
            
            itemImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            urgentContainer.widthAnchor.constraint(equalToConstant: 80),
            urgentContainer.heightAnchor.constraint(equalToConstant: 25),
            urgentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            urgentContainer.topAnchor.constraint(equalTo: itemImage.topAnchor, constant: 8),
            
            urgentLabel.centerXAnchor.constraint(equalTo: urgentContainer.centerXAnchor),
            urgentLabel.centerYAnchor.constraint(equalTo: urgentContainer.centerYAnchor),
            
            titleItemLabel.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 8),
            titleItemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleItemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            priceItemLabel.topAnchor.constraint(equalTo: titleItemLabel.bottomAnchor, constant: 8),
            priceItemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priceItemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryItemLabel.topAnchor.constraint(equalTo: priceItemLabel.bottomAnchor, constant: 8),
            categoryItemLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryItemLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryItemLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}

