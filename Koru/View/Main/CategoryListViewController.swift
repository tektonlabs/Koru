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


class CategoryListViewController: UIViewController {
    
    var sectionArray = [SectionType.selectAllCell, .categoryCell]
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var viewModel = CategoryListViewModel()
    var refugeSelected: Refuge!
    var loadingView: LoadingView!
    var emptyView: EmptyView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fillData()
        setupNavigation()
        setupCollectionView()
        setupAction()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        categoryCollectionView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupEmptyView()
        setupLoadingView()
        viewModel.needLoading = true
    }
    
    func setupNavigation() {
        navigationItem.title = "Categorías"
    }

    func setupCollectionView() {
        categoryCollectionView.isHidden = true
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self

        let categorryCellXib = UINib(nibName: SectionType.categoryCell.nibName, bundle: nil)
        categoryCollectionView.register(categorryCellXib, forCellWithReuseIdentifier: SectionType.categoryCell.identifier)
        
        let selectAllCellXib = UINib(nibName: SectionType.selectAllCell.nibName, bundle: nil)
        categoryCollectionView.register(selectAllCellXib, forCellWithReuseIdentifier: SectionType.selectAllCell.identifier)
        
        let deselectAllCellXib = UINib(nibName: SectionType.deselectAllCell.nibName, bundle: nil)
        categoryCollectionView.register(deselectAllCellXib, forCellWithReuseIdentifier: SectionType.deselectAllCell.identifier)
        
        let continueCellXib = UINib(nibName: SectionType.continueCell.nibName, bundle: nil)
        categoryCollectionView.register(continueCellXib, forCellWithReuseIdentifier: SectionType.continueCell.identifier)
    }
    
    //Mark: Action
    
    func setupAction() {
        viewModel.didSelectedCategory = { [weak self] in
            self?.addContinueSection()
        }
        
        viewModel.didSelectedAll = { [weak self] in
            self?.categoryCollectionView.reloadData()
        }
        
        viewModel.didLoading = { [weak self] in
            self?.categoryCollectionView.isHidden = true
            self?.loadingView.isHidden = false
        }
        
        viewModel.didSuccess = { [weak self] in
            self?.categoryCollectionView.isHidden = false
            self?.loadingView.isHidden = true
            self?.categoryCollectionView.reloadData()
        }
        
        viewModel.didFailure = { [weak self] in
            self?.categoryCollectionView.isHidden = true
            self?.loadingView.isHidden = true
            self?.emptyView.isHidden = false
        }
        
        viewModel.didTouchContinue = { [weak self] in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let questionViewController = storyboard.instantiateViewController(withIdentifier: "listQuestionPageViewController") as! ListQuestionPageViewController
            questionViewController.viewModel.refugeSelected = self?.viewModel.refugeSelected
            let backItem = UIBarButtonItem()
            backItem.title = ""
            self?.navigationItem.backBarButtonItem = backItem
            self?.navigationController?.pushViewController(questionViewController, animated: true)

        }
    }
    
    func setupLoadingView() {
        
        loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isHidden = false
        loadingView.alpha = 1
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }

    func setupEmptyView() {
        emptyView = EmptyView()
        emptyView.messageLabel.text = "Sin conexión a internet"
        emptyView.reloadButton.setTitle("Intertar de nuevo", for: .normal)
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.isHidden = true
        emptyView.alpha = 1
        emptyView.reloadButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    @objc func tryAgain() {
        loadingView.isHidden = false
        emptyView.isHidden = true
        viewModel.callService(refuge: viewModel.refugeSelected)
    }
}

extension CategoryListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = sectionArray[section]
        switch section {
        case .categoryCell: return 8
        case .selectAllCell, .continueCell, .deselectAllCell: return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sectionArray[indexPath.section]
        switch section {
        case .categoryCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as! CategoryCell
            
            if let categories = viewModel.refugeSelected.category {
                if categories.count > 0 {
                cell.titleLabel.text = categories[indexPath.row].name
                cell.fillCategory(image: viewModel.categoryArray[indexPath.row])
                cell.changeBorderColorWith(status: categories[indexPath.row].selected!)
                }
            }
            return cell
        case .selectAllCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as! SelectAllCell
            cell.viewModel.delegate = self
            cell.messageLabel.text = "Selecciona las categorías que quieras completar."
            return cell
        case .continueCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as! ContinueCell
            cell.viewModel.delegate = self
            return cell
        case .deselectAllCell:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: section.identifier, for: indexPath) as! DeselectAllCell
            cell.viewModel.delegate = self
            cell.messageLabel.text = "Selecciona las categorías que quieras completar."
            
            return cell
        }
    }
    
}

extension CategoryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let section = sectionArray[indexPath.section]
        switch  section {
        case .categoryCell:
           let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
           
           viewModel.didSelectCategoryWith(indexPath: indexPath)
           
           if let categories = viewModel.refugeSelected.category {
            if  categories[indexPath.row].selected! {
                cell.viewModel.isSelectedCategory = true
            } else {
                cell.viewModel.isDeselectCategory = true
            }
            
            viewModel.isSelectedCategory = true
            }
        default: break
        }
    }
    
    func addContinueSection() {
        if viewModel.verifyCategoriesStatus() {
            if sectionArray.count < 3 {
                self.categoryCollectionView.performBatchUpdates({
                    self.sectionArray.remove(at: 0)
                    let selectAllIndex = IndexSet(integer: 0)
                    self.categoryCollectionView.deleteSections(selectAllIndex)
                    
                    self.sectionArray.insert(.deselectAllCell, at: 0)
                    let deselectAllIndex = IndexSet(integer: 0)
                    self.categoryCollectionView.insertSections(deselectAllIndex)
                }, completion: nil)
                self.sectionArray.append(.continueCell)
                let index = IndexSet(integer: 2)
                self.categoryCollectionView.insertSections(index)
               
               var offset = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height - categoryCollectionView.contentSize.height
                
                if (categoryCollectionView.contentSize.height - categoryCollectionView.frame.size.height) < 0 {
                    offset -= (categoryCollectionView.contentSize.height - categoryCollectionView.frame.size.height) * -1
                }
                
                self.categoryCollectionView.setContentOffset(CGPoint(x: 0.0, y: offset), animated: true)
                
            }
        } else {
            sectionArray.remove(at: 2)
            let index = IndexSet(integer: 2)
            self.categoryCollectionView.deleteSections(index)
            
            self.categoryCollectionView.performBatchUpdates({
                self.sectionArray.remove(at: 0)
                let selectAllIndex = IndexSet(integer: 0)
                self.categoryCollectionView.deleteSections(selectAllIndex)
                
                self.sectionArray.insert(.selectAllCell, at: 0)
                let deselectAllIndex = IndexSet(integer: 0)
                self.categoryCollectionView.insertSections(deselectAllIndex)
            }, completion: nil)
            

        }

    }
}

extension CategoryListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGSize
        let section = sectionArray[indexPath.section]
        switch  section {
        case .categoryCell: size =  CGSize(width: collectionView.frame.size.width/3.0 - 20, height: collectionView.frame.size.width/3.0 + 30)
        case .selectAllCell: size = CGSize(width: collectionView.frame.size.width, height: 150)
        case .continueCell: size = CGSize(width: collectionView.frame.size.width, height: 113)
        case .deselectAllCell: size = CGSize(width: collectionView.frame.size.width, height: 150)
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let sectionType = sectionArray[section]
        switch sectionType {
        case .categoryCell:
            return UIEdgeInsets(top: 0, left: 20 , bottom: 0, right: 20)
        case .selectAllCell, .continueCell, .deselectAllCell:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        }
    }
}

extension CategoryListViewController: SelectAllCellViewModelDelegate {
    func didTouchButtonSelectAll(Cell: UICollectionViewCell) {
        sectionArray.remove(at: 0)
        sectionArray.insert(.deselectAllCell, at: 0)
        sectionArray.append(.continueCell)
        viewModel.selectAll()
    }
}

extension CategoryListViewController: DeselectAllCellViewModelDelegate {
    func didTouchButtonDeselectAll(Cell: UICollectionViewCell) {
        sectionArray.remove(at: 0)
        sectionArray.insert(.selectAllCell, at: 0)
        sectionArray.remove(at: 2)
        viewModel.deselectAll()
    }
}

extension CategoryListViewController: ContinueCellViewModelDelegate {
    func didTouchButton(cell: ContinueCell) {
        self.sectionArray = [SectionType.selectAllCell, .categoryCell]
        viewModel.touchedContinue = true
    }
}



extension CategoryListViewController {
    
    enum SectionType: Int {
        case categoryCell
        case continueCell
        case selectAllCell
        case deselectAllCell
        
        var identifier: String {
            switch self {
            case .categoryCell: return "categoryCell"
            case .continueCell: return "continueCell"
            case .selectAllCell: return "selectAllCell"
            case .deselectAllCell: return "deselecAllCell"
            }
        }
        
        var nibName: String {
            switch self {
            case .categoryCell: return "CategoryCell"
            case .continueCell: return "ContinueCell"
            case .selectAllCell: return "SelectAllCell"
            case .deselectAllCell: return "DeselectAllCell"
            }
        }
    }
}


