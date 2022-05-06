//
//  AccountController.swift
//  CULibraries
//
//  Created by 过仲懿 on 5/2/22.
//

import Foundation
import UIKit

class AccountController: UIViewController {
    
    
//    let yourReservation = UILabel()
    let reservationsTable = UITableView()
    let library_columnname = UILabel()
    let time_columnname = UILabel()
    var parentClass: LibraryController!
    var reservations: [Booking] = []
    let refresh = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Reservations"
        view.backgroundColor = .clear

        // MARK: Navigation Bar Setup
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        

        library_columnname.text = "Library/Room"
        library_columnname.textColor = .white
        library_columnname.font = UIFont(name: "Avenir Medium", size: 16)
        library_columnname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(library_columnname)
        
        time_columnname.text = "Time"
        time_columnname.textColor = .white
        time_columnname.font = UIFont(name: "Avenir Medium", size: 16)
        time_columnname.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(time_columnname)
        
        reservationsTable.separatorColor = .clear
        reservationsTable.backgroundColor = .clear
        reservationsTable.dataSource = self
        reservationsTable.delegate = self
        reservationsTable.register(AccountReservationCell.self, forCellReuseIdentifier: "reuseIdentifier")
        reservationsTable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reservationsTable)
        

        refresh.tintColor = .white
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        reservationsTable.refreshControl = refresh
//        view.refreshControl = refresh
        
        setupConstraints()
        refreshData()
    }
    
    func setupConstraints() {

        NSLayoutConstraint.activate([
            library_columnname.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            library_columnname.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])

        NSLayoutConstraint.activate([
            time_columnname.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            time_columnname.topAnchor.constraint(equalTo: library_columnname.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            reservationsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            reservationsTable.topAnchor.constraint(equalTo: library_columnname.bottomAnchor, constant: 10),
            reservationsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            reservationsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -14)
        ])
    }
    
    @objc func refreshData() {
        NetworkManager.getAllBooking(userid: LoginManager.username!) { bookings in
            self.reservations = bookings
            self.reservationsTable.reloadData()
            self.refresh.endRefreshing()
        }
    }
}

extension AccountController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            NetworkManager.deleteBooking(bookingid: reservations[indexPath.row].id!) { booking in
                print(booking)
            }
            reservations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}

extension AccountController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = reservationsTable.dequeueReusableCell(withIdentifier: "reuseIdentifier") as? AccountReservationCell {
            cell.parentVC = self
            let selected_booking = reservations[indexPath.row]
            cell.configure(booking: selected_booking)
            return cell
            } else {
                return UITableViewCell()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reservations.count
    }
}

