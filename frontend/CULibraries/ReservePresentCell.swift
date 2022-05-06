//
//  ReservePresentCell.swift
//  CULibraries
//
//  Created by 过仲懿 on 5/4/22.
//

import Foundation
import UIKit

protocol ReservePresentCellDelegate: AnyObject {
    func reserveRoom(index: Int)
}

class ReservePresentCell: UITableViewCell{
    
    static let id = "ReservePresentCellId"
    
    weak var delegate: ReservePresentCellDelegate?
    
    var people_icon = UIImageView()
    var capacityLabel = UILabel()
    var timeLabel = UILabel()
    
    var rowPressed : Int?
    var isReserved = false
    var parentVC: ReservePresentController!
    
    lazy var reserveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        return button
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(hexString: "E4E0DA")
        selectionStyle = .none
        
        people_icon.tintColor = .gray
        people_icon.image = UIImage(systemName: "person.2.fill")
        people_icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(people_icon)
        
        capacityLabel.font = .boldSystemFont(ofSize: 15)
        capacityLabel.textAlignment = .left
        capacityLabel.textColor = .systemGray
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(capacityLabel)
        
        timeLabel.textColor = .black
        timeLabel.font = UIFont(name: "Avenir Medium", size: 16)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        reserveButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
        reserveButton.setTitle("Reserve", for: .normal)
        reserveButton.setTitleColor(.white, for: .normal)
        reserveButton.backgroundColor = UIColor(hexString: "#E02424")
        reserveButton.layer.cornerRadius = 16
        reserveButton.addTarget(self, action: #selector(reserve), for: .touchUpInside)
        reserveButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reserveButton)
        setUpContraints()
    }
    
    
    @objc func reserve() {
        if !isReserved {
            UIView.animate(withDuration: 0.1, animations: {self.reserveButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)}, completion: { _ in UIView.animate(withDuration: 0.1) {self.reserveButton.transform = CGAffineTransform.identity}})
            reserveButton.setTitleColor(UIColor(hexString: "359A33"), for: .normal)
            reserveButton.backgroundColor = UIColor.white
            reserveButton.setTitle("  ✓  ", for:.normal)
            reserveButton.layer.borderColor = UIColor(hexString: "359A33").cgColor
            reserveButton.layer.borderWidth = 2
            isReserved = true
            if let rowPressed = rowPressed {
                delegate?.reserveRoom(index: rowPressed)
            }
        }
    }
    
    func configure(capacity: String, timeslot: Int) {
        capacityLabel.text = capacity
        timeLabel.text = "\(timeslot):00 - \(timeslot + 1):00"
    }
    func setUpContraints() {
        
        NSLayoutConstraint.activate([
            people_icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            people_icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            people_icon.widthAnchor.constraint(equalToConstant: 16),
            people_icon.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        NSLayoutConstraint.activate([
            capacityLabel.leadingAnchor.constraint(equalTo: people_icon.trailingAnchor, constant: 5),
            capacityLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reserveButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            reserveButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            reserveButton.widthAnchor.constraint(equalToConstant: 100),
            reserveButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




