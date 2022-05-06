//
//  ReserveCell.swift
//  CULibraries
//
//  Created by 张译文 on 2022-04-28.
//

import UIKit

class ReserveCell: UITableViewCell{
    static let id = "ReserveCellId"
    
    var background = UIView()
    var people_icon = UIImageView()

    
    var roomLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir Heavy", size: 16)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    
    var capacityLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        label.textColor = .systemGray
        return label
    }()
    
    var reservedOrNot: Bool?
    var selfReserved = false
    var parentVC: LibraryController!
    var availableTime: [Int]?
    
    var room_id: Int?
    
    lazy var reserveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        background.backgroundColor = .white
        background.layer.cornerRadius = 15
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)
        
        [roomLabel, capacityLabel, reserveButton].forEach {subView in
            subView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subView)
        }
        
        reserveButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
        
        people_icon.image = UIImage(systemName: "person.2.fill")
        people_icon.tintColor = .gray
        people_icon.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(people_icon)
        
        setupconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func reserve() {
        let presentWindow = ReservePresentController()
        presentWindow.parentVC = self
        presentWindow.room_id = room_id
        presentWindow.availabelTimeSlots = availableTime
        self.window?.rootViewController?.present(presentWindow, animated: true, completion: nil)
    }

    

    func configure(room:Room) {
        roomLabel.text = room.name
        capacityLabel.text = "\(room.capacity!)"
        availableTime = room.availability
        
        if reservedOrNot! {
            reserveButton.setTitle("Booked", for: .normal)
            reserveButton.setTitleColor(.white, for: .normal)
            reserveButton.backgroundColor = UIColor.lightGray
        } else {
            reserveButton.setTitle("Reserve", for: .normal)
            reserveButton.setTitleColor(.white, for: .normal)
            reserveButton.backgroundColor = UIColor(hexString: "E02424")
            reserveButton.addTarget(self, action: #selector(reserve), for: .touchUpInside)
        }
    }
    
    func setupconstraints() {
        let padding : CGFloat = 15
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            roomLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            roomLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            roomLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            capacityLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            capacityLabel.centerYAnchor.constraint(equalTo: roomLabel.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            people_icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -20),
            people_icon.centerYAnchor.constraint(equalTo: capacityLabel.centerYAnchor),
            people_icon.widthAnchor.constraint(equalToConstant: 16),
            people_icon.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        NSLayoutConstraint.activate([
            reserveButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
            reserveButton.centerYAnchor.constraint(equalTo: roomLabel.centerYAnchor),
            reserveButton.widthAnchor.constraint(equalToConstant: 100),
            reserveButton.heightAnchor.constraint(equalToConstant: 32)
        ])

    }
}

