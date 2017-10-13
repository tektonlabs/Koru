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

class RefugeListViewController: UIViewController {

    var refugeListTableView: UITableView!
    
    var addButton: SAButton!
    
    let viewModel = RefugeListViewModel()
    var refreshControl: UIRefreshControl!
    var loadingView: LoadingView!
    var emptyView: EmptyView!
    var searchEmptyView: SearchEmptyView!
    var searchBar: UISearchBar!
    var searchButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    var syncButton: UIBarButtonItem!
    var tableViewTopContraint: NSLayoutConstraint!
    var timer = Timer()
    var isActiveSearchBar = false
    let shouldShowAddButton: Bool = {
        guard let currentEnumeratorUser = EnumeratorUserManager.sharedInstance.currentEnumeratorUser else {
            return false
        }
        
        return currentEnumeratorUser.isActive
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyView()
        setupBinding()
        setupNavigation()
        setupAction()
        setupSearchEmptyView()
        
        if (shouldShowAddButton) {
            setupAddButton()
        }
        setupTableView()
        setupPullToRefresh()
        setupNotification()
        viewModel.sendPendingQuestionForm()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLoadingView()
        viewModel.morePages = true
        viewModel.needLoading = true
    }
    
    // Mark: Setup tableView
    
    func setupTableView() {
        refugeListTableView = UITableView()
        refugeListTableView.dataSource = self
        refugeListTableView.delegate   = self
        refugeListTableView.rowHeight = UITableViewAutomaticDimension
        refugeListTableView.estimatedRowHeight = 85
        refugeListTableView.separatorStyle = .none
        refugeListTableView.keyboardDismissMode = .onDrag
        let cellXib = UINib(nibName: "RefugeCell", bundle: nil)
        refugeListTableView.register(cellXib, forCellReuseIdentifier: "refugeCell")
        
        let loadingCellXib = UINib(nibName: "LoadingCell", bundle: nil)
        refugeListTableView.register(loadingCellXib, forCellReuseIdentifier: "loadingCell")
        
        refugeListTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(refugeListTableView)

        tableViewTopContraint = NSLayoutConstraint(item:  refugeListTableView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        tableViewTopContraint.isActive = true
        if shouldShowAddButton  {
            refugeListTableView.bottomAnchor.constraint(equalTo: self.addButton.topAnchor, constant: -8).isActive = true
        } else {
            refugeListTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        }
        refugeListTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        refugeListTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    //Mark: Setup Navigation
    func setupNavigation() {
        navigationItem.title = "Segundos Auxilios"
         searchButton = UIBarButtonItem(image: UIImage(named: "search-icon"), style: .plain, target: self, action: #selector(didTouchSearchButton))
        cancelButton = UIBarButtonItem(image: UIImage(named: "cancel-nav-button"), style: .plain, target: self, action: #selector(didTouchSearchCancelButton))
        syncButton = UIBarButtonItem(image: UIImage(named: "sync-icon"), style: .plain, target: self, action: #selector(didTouchSyncButton))
        navigationItem.rightBarButtonItems = [searchButton]
    }
    
    //Mark: Setup Search Bar
    @objc func didTouchSyncButton() {
        viewModel.sendPendingQuestionForm()
        viewModel.offset = 0
        viewModel.listRefuge.removeAll()
        viewModel.morePages = true
        viewModel.needLoading = true
    }
    
    @objc func didTouchSearchButton() {
        viewModel.isTouchedSearch = true
    }
    
    @objc func didTouchSearchCancelButton() {
        viewModel.isActiveSearchBar = false
        viewModel.isTouchedSearchCancelButton = true
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(receivedSendQuestionFormNotification(notification:)), name: NSNotification.Name(rawValue: NotificationManager.sharedInstance.notificationSendQuestionForm), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedFailureSendQuestionForm(notification:)), name: NSNotification.Name(rawValue: NotificationManager.sharedInstance.notificationFailureSendQuestionForm), object: nil)
    }
    
    @objc func receivedSendQuestionFormNotification(notification : NSNotification) {

        OperationQueue.main.addOperation { () -> Void in
            self.refugeListTableView.reloadData()
            self.navigationItem.rightBarButtonItems = [self.searchButton]

            let alertController = UIAlertController(title: "El formulario fue enviado exitosamente.", message: "", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Confirmar", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            }
    }

    @objc func receivedFailureSendQuestionForm(notification: NSNotification) {

        OperationQueue.main.addOperation { () -> Void in
            self.navigationItem.rightBarButtonItems = [self.syncButton, self.searchButton]

            let alertController = UIAlertController(title: "No se pudo enviar el formulario.", message: "La aplicación lo intentará de nuevo una vez que se establezca una conexión a internet.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Confirmar", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }

    }
    
    func setupSearchBar() {
        
        navigationItem.rightBarButtonItems = [cancelButton]
        searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.alpha = 1
        searchBar.delegate = self
        searchBar.placeholder = "Buscar"
        self.view.addSubview(searchBar)
       
        
        UIView.animate(withDuration: 0.25, animations: {
            self.searchBar.alpha = 1
            self.tableViewTopContraint.constant = 44
            self.refugeListTableView.superview?.layoutIfNeeded()
        }, completion: { (true) in
            self.viewModel.isActiveSearchBar = true
            self.tableViewTopContraint.isActive = false
            NSLayoutConstraint(item: self.searchBar, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
            self.searchBar.bottomAnchor.constraint(equalTo: self.refugeListTableView.topAnchor).isActive = true
            self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
            self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        })
    }
    
    func removeSearchBar() {
        viewModel.offset = 0
        viewModel.morePages = true
        viewModel.cancelSearch = true
        viewModel.searchText = ""
        viewModel.isActiveSearchBar = false
        tableViewTopContraint.isActive = true
        UIView.animate(withDuration: 0.25, animations: {
            self.searchBar.alpha = 0
            self.tableViewTopContraint.constant = 0
            self.refugeListTableView.superview?.layoutIfNeeded()
        }, completion: { (true) in
            self.searchBar.removeFromSuperview()
            if self.viewModel.pendingFormVerify() {
                self.navigationItem.rightBarButtonItems = [self.syncButton, self.searchButton]
            } else {
                self.navigationItem.rightBarButtonItems = [self.searchButton]
            }


        })
    }

    func setupAddButton() {
        self.addButton = SAButton()
        self.addButton.setTitle("Agregar albergue", for: .normal)
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.addButton.addTarget(self, action: #selector(RefugeListViewController.didTapAddNewButton), for: .touchUpInside)
        
        self.view.addSubview(addButton)
        
        self.addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        self.addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        self.addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
    // Mark: Setup Pull Refresh
    
    func setupPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)

        refugeListTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender: AnyObject) {
        viewModel.needsPullRefresh = true
        refreshControl.endRefreshing()
    }
    
    // Mark: Setup Action
    func setupAction() {
        viewModel.didLoading = { [weak self] in
            self?.refugeListTableView.isHidden = true
            self?.loadingView.alpha = 1
            self?.loadingView.isHidden = false
        }
        
        viewModel.showEmptyView = { [weak self] in
            self?.loadingView.alpha = 0
            self?.loadingView.isHidden = true
            self?.emptyView.alpha = 1
            self?.emptyView.isHidden = false
        }
        
        viewModel.didTouchSearchButton = { [weak self] in
            self?.isActiveSearchBar = true
            self?.setupSearchBar()
        }
        
        viewModel.didTouchSearchCancelButton = { [weak self] in
            self?.isActiveSearchBar = false
            self?.removeSearchBar()
        }
        
        viewModel.showSearchEmptyView = { [weak self] in
            self?.refugeListTableView.isHidden = true
            self?.searchEmptyView.alpha = 1
            self?.searchEmptyView.isHidden = false
        }
        
        viewModel.theArePending = { [weak self] in
            self?.addSyncronizeButton()
        }
    }
    
    
    // Mark: Setup Data Binding
    func setupBinding() {
        
        viewModel.didReachLastPage = {
            let indexPath = IndexPath(item: self.viewModel.listRefuge.count, section: 0)
            if let _  = self.refugeListTableView.cellForRow(at: indexPath) {
                self.refugeListTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
        viewModel.didChangeListRefuge = { [weak self] in
            self?.refugeListTableView.reloadData()
            self?.refugeListTableView.isHidden = false
        }
        
        viewModel.didSuccessLoading = { [weak self] in
            self?.refugeListTableView.isHidden = false
            self?.emptyView.alpha = 0
            self?.emptyView.isHidden = true
            self?.loadingView.alpha = 0
            self?.loadingView.isHidden = true
            self?.searchEmptyView.isHidden = true
            self?.searchEmptyView.alpha = 0
        }
        
        viewModel.didScrollBottom = { [weak self] in
            self?.refugeListTableView.reloadData()
        }
        
        viewModel.didSelectRefuge = { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoryViewController = storyboard.instantiateViewController(withIdentifier: "categoryListViewController") as! CategoryListViewController
            categoryViewController.viewModel.refugeSelected = self?.viewModel.refugeSelected
            if self?.viewModel.isActiveSearchBar == true {
                self?.viewModel.isTouchedSearchCancelButton = true
            }
            self?.navigationController?.pushViewController(categoryViewController, animated: true)
            self?.viewModel.offset = 0
            self?.viewModel.listRefuge.removeAll()
        }
        
    }

    
    func setupLoadingView() {
        
        loadingView = LoadingView()
        loadingView.backgroundColor = UIColor.white
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = false
        loadingView.alpha = 0
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func setupEmptyView() {
        emptyView = EmptyView()
        emptyView.messageLabel.text = "No se encontraron albergues"
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        emptyView.alpha = 0
        emptyView.reloadButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func setupSearchEmptyView() {
        searchEmptyView = SearchEmptyView()
        searchEmptyView.translatesAutoresizingMaskIntoConstraints = false
        searchEmptyView.alpha = 0
        searchEmptyView.isHidden = true
        self.view.addSubview(searchEmptyView)
        searchEmptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.searchEmptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.searchEmptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.searchEmptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
    }
    
    func addSyncronizeButton() {
        if isActiveSearchBar == false {
            navigationItem.rightBarButtonItems = [syncButton ,searchButton]
        }
    }
    
    @objc func tryAgain() {
        loadingView.alpha = 1
        loadingView.isHidden = false
        emptyView.alpha = 0
        emptyView.isHidden = true
        viewModel.offset = 0
        viewModel.callRefugeServiceWith(viewModel.currentLocation)
    }

    @objc func didTapAddNewButton() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let createRefugeViewController = mainStoryboard.instantiateViewController(withIdentifier: "CreateRefugeViewController") as? CreateRefugeViewController {
            let navigationController = InitialNavigationController()
            navigationController.setViewControllers([createRefugeViewController], animated: false)
            self.present(navigationController, animated: true, completion: nil)
        }
    }
}

extension RefugeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.morePages {
            return viewModel.listRefuge.count + 1
        } else {
            return viewModel.listRefuge.count
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.morePages {
                if indexPath.row == viewModel.listRefuge.count {
                    return createLoadingCell(indexPath: indexPath)
                } else {
                    return  createRefugeCell(indexPath: indexPath)
                }
        } else {
              return  createRefugeCell(indexPath: indexPath)
        }

    }
    
    private func createRefugeCell(indexPath: IndexPath) -> RefugeCell {
        let cell = refugeListTableView.dequeueReusableCell(withIdentifier: "refugeCell", for: indexPath) as! RefugeCell
        let list = viewModel.listRefuge
        let status =  list[indexPath.row].status
        cell.titleLabel.text = "\(list[indexPath.row].name!)"
        cell.pendingQuestionLabel.text = ""
        cell.locationLabel.text = viewModel.formLocationTextWith(refuge: list[indexPath.row])
        if let pendingSortedQuestion = list[indexPath.row].pendingSortedQuestion {
            if pendingSortedQuestion.count > 0 {
                cell.pendingQuestionLabel.text = "\(pendingSortedQuestion.count) fomulario(s) pendiente(s)."
            } else {
                cell.pendingQuestionLabel.text = ""
            }
        }
       
        cell.viewModel.verify(status: status!)
        
        return cell
    }
    
    private func createLoadingCell(indexPath: IndexPath) -> LoadingCell {
        let cell = refugeListTableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath) as! LoadingCell
        cell.viewModel.isLoading = true
        return cell
    }
    
}

extension RefugeListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < viewModel.listRefuge.count {
            viewModel.refugeSelected = viewModel.listRefuge[indexPath.row]
            viewModel.isSelectRefuge = true
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if viewModel.morePages {
            let posY = scrollView.contentOffset.y + scrollView.frame.size.height
            if posY >= scrollView.contentSize.height {
                refugeListTableView.reloadData()
                viewModel.callRefugeServiceWith(viewModel.currentLocation)
                viewModel.isScrollBottom = true
            }
        }
    }
}

extension RefugeListViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.offset = 0
        viewModel.morePages = true
        viewModel.cancelSearch = true
        searchBar.text = ""
        viewModel.searchText = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.offset = 0
        viewModel.morePages = true
        viewModel.cancelSearch = true
        viewModel.searchText = searchText
        
        
    }
}

