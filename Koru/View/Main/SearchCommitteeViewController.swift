/* 

=========================================================================== 
Koru GPL Source Code 
Copyright (C) 2017 Tekton Labs
This file is part of the Koru GPL Source Code.
Koru Source Code is free software: you can redistribute it and/or modify 
it under the terms of the GNU General Public License as published by 
the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. 

Koru Source Code is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License 
along with Koru Source Code. If not, see <http://www.gnu.org/licenses/>. 
=========================================================================== 

*/

import UIKit
protocol SearchCommitteeViewControllerDelegate: class {
    func didSelectOption(viewContronller: SearchCommitteeViewController)
}

class SearchCommitteeViewController: UIViewController {
    
    var viewModel: AddSearchResultViewModel?
    weak var delegate: SearchCommitteeViewControllerDelegate?
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    fileprivate var filteredResults = [SearchResult]()
    fileprivate var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar Comités"
        view.backgroundColor = UIColor.white
        searchController.searchBar.placeholder = "Buscar"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        configureTableView()
    }
    
    func configureTableView() {
        tableView.tableHeaderView = searchController.searchBar
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String) {
        guard searchText.characters.count >= 3 else {
            return
        }
        
        CommitteeService.search(searchText) { (committees, error) in
            if let error = error {
                let alertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.filteredResults = committees!
                self.tableView.reloadData()
            }
        }
    }
}

extension SearchCommitteeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let result = filteredResults[indexPath.row]
        cell.textLabel!.text = result.title
        return cell
    }
}

extension SearchCommitteeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = filteredResults[indexPath.row]
        self.viewModel?.result = result
        self.delegate?.didSelectOption(viewContronller: self)
    }
}

extension SearchCommitteeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
