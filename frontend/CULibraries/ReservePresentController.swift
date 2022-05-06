//
//  ReservePresentController.swift
//  CULibraries
//
//  Created by 过仲懿 on 5/4/22.
//

import Foundation
import UIKit

class ReservePresentController: UIViewController {
    
    var new_title = UILabel()
    var clock_icon = UIImageView()
    var roomNum = UILabel()
    var roomTable = UITableView()
    var parentVC: ReserveCell!
    var availabelTimeSlots: [Int]?
    
    var done_button = UIButton()
    var cancel_button = UIButton()
    
    var room_id: Int?
    override func viewDidLoad() {
        
        view.backgroundColor = .systemBackground
        
        roomNum.text = "Room \(parentVC.roomLabel.text!)"
        roomNum.font = UIFont(name: "Avenir Heavy", size: 30)
        roomNum.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roomNum)
        
        new_title.text = "Available Slots"
        new_title.font = UIFont(name: "Avenir Heavy", size: 24)
        new_title.textColor = UIColor(hexString: "E02424")
        new_title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(new_title)
        
        clock_icon.image = UIImage(named: "clock")
        clock_icon.tintColor = .black
        clock_icon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(clock_icon)
    
        roomTable.delegate = self
        roomTable.dataSource = self
        roomTable.register(ReservePresentCell.self, forCellReuseIdentifier: ReservePresentCell.id)
        roomTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roomTable)
        
        done_button.setTitle("Done", for: .normal)
        
        done_button.setTitleColor(.white, for: .normal)
        done_button.titleLabel?.font = UIFont(name: "Avenir Medium", size: 18)
        done_button.backgroundColor = UIColor(hexString: "E02424")
        done_button.layer.cornerRadius = 24
        done_button.addTarget(self, action: #selector(done), for: .touchUpInside)
        done_button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(done_button)
        
        cancel_button.setTitle("Cancel", for: .normal)
        cancel_button.titleLabel?.font = UIFont(name: "Avenir Medium", size: 18)
        cancel_button.setTitleColor(UIColor(hexString: "E02424"), for: .normal)
        cancel_button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancel_button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancel_button)
        
        setUpContraints()
    }
    
    func setUpContraints() {
        
        NSLayoutConstraint.activate([
            roomNum.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            roomNum.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30)
        ])
        
        
        NSLayoutConstraint.activate([
            clock_icon.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            clock_icon.topAnchor.constraint(equalTo: roomNum.bottomAnchor, constant: 20),
            clock_icon.widthAnchor.constraint(equalToConstant: 110),
            clock_icon.heightAnchor.constraint(equalToConstant: 110),
        ])
        
        
        NSLayoutConstraint.activate([
            new_title.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            new_title.topAnchor.constraint(equalTo: clock_icon.bottomAnchor, constant: 20)
        ])

        
        NSLayoutConstraint.activate([
            cancel_button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            cancel_button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            done_button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            done_button.bottomAnchor.constraint(equalTo: cancel_button.topAnchor, constant: -20),
            done_button.widthAnchor.constraint(equalToConstant: 140),
            done_button.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        
        NSLayoutConstraint.activate([
            roomTable.topAnchor.constraint(equalTo: new_title.bottomAnchor, constant: 20),
            roomTable.bottomAnchor.constraint(equalTo: done_button.topAnchor, constant: -10),
            roomTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            roomTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14)
        ])
    }
    
    @objc func done() {
        // TODO: send request
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ReservePresentController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availabelTimeSlots!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReservePresentCell.id, for: indexPath) as! ReservePresentCell
        cell.parentVC = self
        cell.configure(capacity: parentVC.capacityLabel.text!, timeslot: availabelTimeSlots![indexPath.row])
        cell.rowPressed = indexPath.row
        cell.delegate = self
//        cell.capacityNum = self.parentVC.capacityLabel.text
//        cell.configure(room: rooms[indexPath.row])
        return cell
    }
}

extension ReservePresentController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10    //if you want round edges
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: verticalPadding/2)
        cell.layer.mask = maskLayer
    }
}

extension ReservePresentController: ReservePresentCellDelegate {
    func reserveRoom(index: Int) {
        NetworkManager.createBooking(netId: LoginManager.username!, roomId: self.room_id!, timeStart: availabelTimeSlots![index]) { booking in
            print(booking)
        }
    }
}
