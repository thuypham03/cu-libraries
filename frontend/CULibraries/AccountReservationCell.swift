//
//  AccountReservationCell.swift
//  CULibraries
//
//  Created by 过仲懿 on 5/2/22.
//

import Foundation
import UIKit

class AccountReservationCell: UITableViewCell {
    
    var delegate: ReserveTableController?
    var name = UILabel()
    var backGround = UIView()
    var time = UILabel()
//    var cancel_button = UIButton()
    var parentVC: AccountController!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        backGround.backgroundColor = .white
        backGround.layer.cornerRadius = 15
        backGround.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backGround)
        
        name.font = UIFont(name: "Avenir Medium", size: 16)
        name.textAlignment = .left
        name.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(name)

        
        time.font = UIFont(name: "Avenir Medium", size: 14)
        time.textAlignment = .center
        time.textColor = .gray
        time.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(time)

//        cancel_button.setTitle("Cancel", for: .normal)
//        cancel_button.setTitleColor(.white, for: .normal)
//        cancel_button.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
//        cancel_button.backgroundColor = UIColor(hexString: "#B31B1B")
//        cancel_button.layer.cornerRadius = 16
//        cancel_button.addTarget(cancel, action: #selector(cancel), for: .touchUpInside)
//        cancel_button.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(cancel_button)
       
        setupConstraints()
    }
    
    
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            backGround.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backGround.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            backGround.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            backGround.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
//        NSLayoutConstraint.activate([
//            name.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
//            name.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
//            name.widthAnchor.constraint(equalToConstant: 120)
//        ])
//
//        NSLayoutConstraint.activate([
//            time.leadingAnchor.constraint(equalTo: name.trailingAnchor, constant: 20),
//            time.centerYAnchor.constraint(equalTo: name.centerYAnchor)
//        ])
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            name.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
//            name.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            time.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            time.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor)
        ])
        
//        NSLayoutConstraint.activate([
//            cancel_button.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
//            cancel_button.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
//            cancel_button.widthAnchor.constraint(equalToConstant: 80),
//            cancel_button.heightAnchor.constraint(equalToConstant: 32)
//        ])
    }
    
    func configure(booking: Booking) {
        name.text = "\(booking.libraryName!) \(booking.roomName!)"
        time.text = "\(booking.timeStart!):00 - \(booking.timeStart! + 1):00"
    }
    
//    @objc func cancel() {
//        let alert = UIAlertController(title: "Cancel Your Reservation", message: "Are your sure that you want to cancel your reservation?", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
//            return
//        })
//
//        let cancel = UIAlertAction(title: "Don't Cancel", style: .cancel) {(action) -> Void in
//            return
//        }
//        alert.addAction(ok)
//        alert.addAction(cancel)
//        parentVC.present(alert, animated: true)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

