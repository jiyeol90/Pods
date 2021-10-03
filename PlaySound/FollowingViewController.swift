//
//  FollowingViewController.swift
//  PlaySound
//
//  Created by james on 2021/09/28.
//

import UIKit

class FollowingViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var arr = ["Zedd", "Alan Walker", "David Guetta", "Avicii", "Marshmello", "Steve Aoki", "R3HAB", "Armin van Buuren", "Skrillex", "Illenium", "The Chainsmokers", "Don Diablo", "Afrojack", "Tiesto", "KSHMR", "DJ Snake", "Kygo", "Galantis", "Major Lazer", "Vicetone"
    ]
    
    var filteredArr: [String] = []
    
    var isFiltering: Bool {
        let searchController = self.navigationItem.searchController
        let isActive = searchController?.isActive ?? false
        let isSearchBarHasText = searchController?.searchBar.text?.isEmpty == false
        return isActive && isSearchBarHasText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setupSearchController()
        self.setupTableView()
        self.registerXib()
    }
    
    func setupSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search following"
        //검색결과를 보여줄때 뷰컨트롤러를 가린다. (배경만 어둡게 하는게 아니다.)
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchResultsUpdater = self
        //self.navigationController?.navigationBar.topItem?.searchController = searchController
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Following"
        
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //테이블 뷰의 seperator를 아이템의 개수만큼만 표시해준다.
        self.tableView.tableFooterView = UIView()
    }
    
    func registerXib() {
        let nibName = UINib(nibName:"FollowTableViewCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "followTableViewCell")
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FollowingViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isFiltering ? self.filteredArr.count : self.arr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        if self.isFiltering {
//            cell.textLabel?.text = self.filteredArr[indexPath.row]
//        } else {
//            cell.textLabel?.text = self.arr[indexPath.row]
//        }
//
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followTableViewCell", for: indexPath) as! FollowTableViewCell

        if self.isFiltering {
            cell.nickName.text = self.filteredArr[indexPath.row]
        } else {
            cell.nickName.text = self.arr[indexPath.row]
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       print("테이블뷰 클릭")
        if self.isFiltering {
            print(self.filteredArr[indexPath.row])
        } else {
            print(self.arr[indexPath.row])
        }
    }
    
}

extension FollowingViewController: UISearchResultsUpdating {
    //searchBar에 Text가 업데이트 될 때마다 불리는 메소드
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text?.lowercased() else { return }
        self.filteredArr = self.arr.filter { $0.localizedCaseInsensitiveContains(text) }
        dump(filteredArr)
        //dump(searchController.searchBar.text)
        
        self.tableView.reloadData()
    }
    
    
    
}
