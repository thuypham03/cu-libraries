//
//  LibraryCellController.swift
//  CULibraries
//
//  Created by 过仲懿 on 4/27/22.
//

import Foundation
import UIKit

class LibraryCellController: UITableViewCell {
    var background = UIView()
    var name = UILabel()
    var photoName = ""
    var photo = UIImageView()
    var status = UILabel()
    var time = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .gray
        
        background.backgroundColor = .white
        background.layer.cornerRadius = 10
        background.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(background)
        
        
        photo.contentMode = .scaleToFill
        photo.layer.cornerRadius = 10
        photo.clipsToBounds = true
        photo.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photo)
        
        name.font = UIFont(name: "Avenir Heavy", size: 16)
        name.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(name)
        
        status.translatesAutoresizingMaskIntoConstraints = false
        status.font = UIFont(name: "Avenir Heavy", size: 14)
        contentView.addSubview(status)

        time.textColor = .gray
        time.font =  UIFont(name: "Arial", size: 12)
        time.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(time)

        setupConstraints()
    }

    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 3),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            photo.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            photo.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photo.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 9/10),
            photo.heightAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: photo.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: photo.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            status.centerYAnchor.constraint(equalTo: name.centerYAnchor),
            status.trailingAnchor.constraint(equalTo: photo.trailingAnchor)
        ])
    
        NSLayoutConstraint.activate([
            time.leadingAnchor.constraint(equalTo: photo.leadingAnchor),
            time.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 3),
            time.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configure(library: Library) {
        name.text = library.name
        time.text = "\(library.timeStart!):00 - \(library.timeEnd!):00"
        photoName = library.photo!
        photo.load(url: URL(string: photoName)!)
        
        var statusValue: Bool

        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        let stringNow = formatter.string(from: currentDateTime)
        let intnow = Int(stringNow)!
        
        if intnow >= library.timeStart! && intnow < library.timeEnd! {
            statusValue = true
        } else {
            statusValue = false
        }
        
        if statusValue {
            status.text = "Open"
            status.textColor = UIColor(hexString: "359A33")
        } else {
            status.text = "Closed"
            status.textColor = UIColor(hexString: "#B31B1B")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LibraryCellController {
    func noSelectionStyle () {
        self.selectionStyle = .none
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
