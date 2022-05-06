//
//  ReserveTableController.swift
//  CULibraries
//
//  Created by 张译文 on 2022-04-28.
//

import UIKit

//protocol ReserveTableControllerDelegate: AnyObject {
//    var room: [Room] { get set }
//}

protocol ReserveTableDelegate {
    func reserveTableDelegate(library: Library)
}


class ReserveTableController: UIViewController {
    
    var delegate: ReserveTableDelegate?
    
    
    var head_title = UILabel()
    var library_id: Int?
    var parentVC: LibraryController!
    var rooms: [Room] = []
    
    lazy var reserveView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ReserveCell.self, forCellReuseIdentifier: ReserveCell.id)
        tableView.separatorInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .clear
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        head_title.text = "Available Rooms"
        head_title.textColor = .white
        head_title.font = UIFont(name: "Avenir Heavy", size: 22)
        head_title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(head_title)
        
        
//        rooms = [Room(id: 1, libraryId: 1, name: "102", capacity: 10, availability: [8, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23])]
        rooms = []
        view.addSubview(reserveView)
        
        refreshData()
        setupConstraint()
    }
    
    func setupConstraint(){
        NSLayoutConstraint.activate([
            head_title.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            head_title.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            reserveView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
            reserveView.topAnchor.constraint(equalTo: head_title.bottomAnchor, constant: 10),
            reserveView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
            reserveView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
    @objc func refreshData() {
        NetworkManager.getAllRoomByID(libraryid: library_id!) { rooms in
            self.rooms = rooms
            self.reserveView.reloadData()
        }
        
    }
}

extension ReserveTableController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReserveCell.id, for: indexPath) as! ReserveCell
//        cell.parentVC = self
        
        if rooms[indexPath.row].availability?.count == 0 {
            cell.reservedOrNot = true
        } else {
            cell.reservedOrNot = false
        }
        cell.room_id = rooms[indexPath.row].id
        cell.configure(room: rooms[indexPath.row])
        return cell
    }
}

extension ReserveTableController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
}
