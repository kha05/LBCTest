//
//  ItemDetailViewController.swift
//  LBCTest
//
//  Created by Ha Kevin on 28/03/2021.
//

import Foundation
import UIKit

final class ItemDetailViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 16
        stackView.setCustomSpacing(32, after: self.itemDateLabel)
        stackView.axis = .vertical
        stackView.accessibilityIdentifier = "ItemDetailViewController_StackView"
        return stackView
    }()
    
    private lazy var urgentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = UIColor.systemOrange
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = !self.viewModel.isUrgentItem
        view.accessibilityIdentifier = "ItemDetailViewController_MarkContainer"
        return view
    }()
    
    private lazy var urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Urgent"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.accessibilityIdentifier = "ItemDetailViewController_UrgentLabel"
        return label
    }()
    
    private lazy var itemImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.accessibilityIdentifier = "ItemDetailViewController_ImageView"
        return imageView
    }()
    
    private lazy var titleItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = view.backgroundColor
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 22)
        label.numberOfLines = 0
        label.text = self.viewModel.itemTitle
        label.accessibilityIdentifier = "ItemDetailViewController_TitleItemLabel"
        return label
    }()
    
    private lazy var descriptionItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = view.backgroundColor
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = self.viewModel.itemDescription
        label.accessibilityIdentifier = "ItemDetailViewController_TitleItemLabel"
        return label
    }()
    
    private lazy var categoryItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = view.backgroundColor
        label.textColor = .gray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = self.viewModel.itemCategory
        label.accessibilityIdentifier = "ItemDetailViewController_TitleItemLabel"
        return label
    }()
    
    private lazy var itemDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = view.backgroundColor
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.text = self.viewModel.itemDate
        label.accessibilityIdentifier = "ItemDetailViewController_ItemDateLabel"
        return label
    }()
    
    private lazy var priceItemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = view.backgroundColor
        label.textColor = .orange
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = self.viewModel.itemPrice
        label.accessibilityIdentifier = "ItemDetailViewController_PriceItemLabel"
        return label
    }()
    
    private let viewModel: ItemDetailViewModelRepresentable
    
    init(viewModel: ItemDetailViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.itemImage { [weak self] image in
            self?.itemImage.image = image
        }
        
        setup()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ItemDetailViewController {
    func setup() {
        setupInterface()
        setupConstraints()
    }
    
    func setupInterface() {
        view.backgroundColor = .white
        
        stackView.addArrangedSubview(titleItemLabel)
        stackView.addArrangedSubview(priceItemLabel)
        stackView.addArrangedSubview(categoryItemLabel)
        stackView.addArrangedSubview(itemDateLabel)
        stackView.addArrangedSubview(descriptionItemLabel)
        
        urgentContainer.addSubview(urgentLabel)
        
        contentView.addSubview(itemImage)
        contentView.addSubview(urgentContainer)
        contentView.addSubview(stackView)
        
        scrollView.addSubview(contentView)
        
        view.addSubview(scrollView)
    }
    
    func setupConstraints() {
        let topConstant: CGFloat
        
        if #available(iOS 13, *) {
            topConstant = 0
        } else {
            topConstant = 16
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            
            itemImage.heightAnchor.constraint(equalToConstant: view.frame.height/2.4),
            itemImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topConstant),
            itemImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            urgentContainer.widthAnchor.constraint(equalToConstant: 104),
            urgentContainer.heightAnchor.constraint(equalToConstant: 32.5),
            urgentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            urgentContainer.topAnchor.constraint(equalTo: itemImage.topAnchor, constant: 32),
            
            urgentLabel.centerXAnchor.constraint(equalTo: urgentContainer.centerXAnchor),
            urgentLabel.centerYAnchor.constraint(equalTo: urgentContainer.centerYAnchor),
            
            stackView.topAnchor.constraint(equalTo: itemImage.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
