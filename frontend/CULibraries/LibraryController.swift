//
//  LibraryController.swift
//  CULibraries
//
//  Created by 过仲懿 on 4/27/22.
//

import UIKit

class LibraryController: UIViewController {
    
    var room: [Room] = []
    
    let libraryTable = UITableView()
    let cellPadding: CGFloat = 20
    
    let libaryCellReuseIdentifier = "libaryCellReuseIdentifier"
    let filterCellReuseIdentifier = "filterCellReuseIdentifier"
    
    let refreshControl = UIRefreshControl()
    
    var library: [Library] = []
    var filteredLibrary : [Library] = []
    var selectedFilter = Set<filterList>()
    let allFilter = [filterList.engineering, filterList.agquad, filterList.artquad]
    
    
    lazy var locationFilter: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        flowLayout.minimumLineSpacing = 15
        flowLayout.minimumInteritemSpacing = 15

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterCellReuseIdentifier)
        
        collectionView.allowsMultipleSelection = true
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.backgroundColor = .clear
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.title = "Libraries"
        view.backgroundColor = .clear
        
        // MARK: NavigationController Setup
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
    
        library = []
        
        filteredLibrary = library


        refreshControl.tintColor = .white
        refreshData()
        
        view.addSubview(locationFilter)
        
        // table view
        libraryTable.separatorColor = .clear
        libraryTable.backgroundColor = .clear
        libraryTable.dataSource = self
        libraryTable.delegate = self
        libraryTable.translatesAutoresizingMaskIntoConstraints = false
        libraryTable.register(LibraryCellController.self, forCellReuseIdentifier: libaryCellReuseIdentifier)
        view.addSubview(libraryTable)

        setUpContraints()
        

    }


    func setUpContraints() {

        NSLayoutConstraint.activate([
            locationFilter.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationFilter.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
            locationFilter.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
            locationFilter.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            libraryTable.topAnchor.constraint(equalTo: locationFilter.bottomAnchor),
            libraryTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            libraryTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            libraryTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }


    func setupViews() {
        if #available(iOS 10.0, *) {
            libraryTable.refreshControl = refreshControl
        } else {
            libraryTable.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
    }
    
    
    @objc func refreshData() {
        NetworkManager.getAllLibrary(completion: { libraries in
            self.library = libraries
            self.filteredLibrary = self.library
            self.libraryTable.reloadData()
//            self.refreshControl.endRefreshing()
        })

    }
    
}

extension LibraryController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

extension LibraryController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = libraryTable.dequeueReusableCell(withIdentifier: libaryCellReuseIdentifier) as? LibraryCellController {
            cell.backgroundColor = .clear
            
            if selectedFilter.isEmpty {
                let selected_library = library[indexPath.row]
//                cell.photoName = selected_library.
                cell.noSelectionStyle()
                cell.configure(library: selected_library)
            } else {
                let selected_library = filteredLibrary[indexPath.row]
                cell.noSelectionStyle()
                cell.configure(library: selected_library)
            }
            return cell
        } else {
                return UITableViewCell()
            }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedFilter.isEmpty {
            return library.count
        }
        return filteredLibrary.count
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let libraryPage = ReserveTableController()
        libraryPage.title = filteredLibrary[indexPath.row].name
        libraryPage.library_id = filteredLibrary[indexPath.row].id
        navigationController?.pushViewController(libraryPage, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.view.layer.opacity = 0
        } completion: { finish in
            if finish {
                self.view.layer.opacity = 1
            }
        }
        

        self.navigationController?.navigationBar.tintColor = .white
    }
}

extension LibraryController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterList.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filterCellReuseIdentifier, for: indexPath) as! FilterCollectionViewCell
        cell.configure(filter: filterList.allCases[indexPath.row].description)
        cell.layer.cornerRadius = 15
        return cell
    }
}

extension LibraryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedFilter.insert(filterList.allCases[indexPath.item])
        self.filteredLibrary = self.library.filter({ (lib) -> Bool in
            var result = false
            [lib.areaId].forEach {libFilter in
                if selectedFilter.contains(allFilter[libFilter!]) {
                    result = true
                }
            }
            return result
        })
        self.libraryTable.reloadData()
    }
}

extension LibraryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedFilter.remove(filterList.allCases[indexPath.item])
        self.filteredLibrary = self.library.filter({ (lib) -> Bool in
            var result = false
            [lib.areaId].forEach { libFilter in
                if selectedFilter.contains(allFilter[libFilter!]) {
                    result = true
                }
            }
            return result
        })
        self.libraryTable.reloadData()
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

