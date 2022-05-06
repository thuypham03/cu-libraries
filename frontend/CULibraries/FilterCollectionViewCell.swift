//
//  FilterCollectionViewCell.swift
//  CULibraries
//
//  Created by 张译文 on 2022-05-01.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    var filterLabel:UILabel = {
        let label = UILabel ()
        label.font = UIFont(name: "Avenir Medium", size: 14)
        label.textColor = UIColor(hexString: "B31B1B")
        label.layer.cornerRadius = 12
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.backgroundColor = UIColor.clear.cgColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        contentView.addSubview(filterLabel)
        NSLayoutConstraint.activate([
            filterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            filterLabel.textColor = isSelected ? .white : UIColor(hexString: "B31B1B")
            self.backgroundColor = isSelected ? UIColor(hexString: "B31B1B") : .white
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(filter: String?) {
        filterLabel.text = filter
    }
}
