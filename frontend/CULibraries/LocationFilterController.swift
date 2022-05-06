//
//  LocationFilterController.swift
//  CULibraries
//
//  Created by 过仲懿 on 4/28/22.
//

import Foundation
import UIKit

class LocationFilterController: UICollectionViewCell {

    static var identifier: String = "Cell"
    
    var filterLabel = UILabel(frame: .zero)
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 2:0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        filterLabel.backgroundColor = .white
        filterLabel.font = .systemFont(ofSize: 12)
        filterLabel.layer.cornerRadius = 20
        filterLabel.textAlignment = .center
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filterLabel)
        
//        setupConstraints()
//    }
//
//    func configure(location: String) {
//        filterLabel.text = location
//    }
//
//
//    func setupConstraints() {
//        NSLayoutConstraint.activate([
//            filterLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
//            filterLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
//            filterLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor),
//            filterLabel.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor)
//        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
