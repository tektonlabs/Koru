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

class CreateRefugeViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContainerView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextArrowImageView: UIImageView!
    @IBOutlet weak var backArrowImageView: UIImageView!
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    
    
    var loadingView: LoadingView!
    var emptyView: EmptyView!
    
    var viewModel: CreateRefugeViewModel!

    fileprivate var pendingIndex: Int?
    
    fileprivate lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(pageViewController)
        self.pageContainerView.addSubview(pageViewController.view)
        return pageViewController
    }()
    
    fileprivate var viewControllers = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nuevo Albergue"
        
        setupNavigationItem()
        setupEmptyView()
        setupButtons()
        setupViewModel()
        setupPageController()
        
        setupLoadingView()
        viewModel.fetchMultipleChoices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(CreateRefugeViewController.didShowKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateRefugeViewController.willHideKeyboard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func didShowKeyboard( notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
            
            bottomLayoutConstraint.constant = keyboardHeight
            
            UIView.animate(withDuration: keyboardAnimationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func willHideKeyboard( notification: Notification) {
        let keyboardAnimationDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        bottomLayoutConstraint.constant = 0
        UIView.animate(withDuration: keyboardAnimationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func setupViewModel() {
        viewModel = CreateRefugeViewModel()
        
        viewModel.didChangePage = { [weak self] in
            if let viewModel = self?.viewModel {
                self?.pageControl.currentPage = viewModel.currentPage
                
                self?.backButton.isHidden = viewModel.currenPageIsFirstPage
                self?.backArrowImageView.isHidden = viewModel.currenPageIsFirstPage
                
                self?.nextButton.isHidden = viewModel.currentPageIsLastPage
                self?.nextArrowImageView.isHidden = viewModel.currentPageIsLastPage
            }
            
        }
        
        viewModel.didStartLoadingMultipleChoices = { [weak self] in
            UIView.animate(withDuration: 0.25, animations: { 
                self?.loadingView.alpha = 1
            })
        }
        
        viewModel.didLoadMultipleChoices = { [weak self] in
            if let viewModel = self?.viewModel {
                self?.pageViewController.setViewControllers([self!.viewControllerForStep(viewModel.currentStep)], direction: .forward, animated: false, completion: nil)
                UIView.animate(withDuration: 0.25, animations: {
                    self?.loadingView.alpha = 0
                    self?.emptyView.alpha = 0
                })
            }
        }
        
        viewModel.didFailLoadingMultipleChoices = { [weak self] (error: Error) in
            self?.emptyView.alpha = 1
            UIView.animate(withDuration: 0.25, animations: {
                self?.loadingView.alpha = 0
                self?.emptyView.messageLabel.text = error.localizedDescription
            })
        }
        
        viewModel.didFailSendingRefugeForm = { [weak self] (error: Error) in
            self?.showAlert(with: error.localizedDescription)
        }
        
        viewModel.didSendRefugeForm = { [weak self] in
            self?.showAlert(with: "El albergue fue creado exitosamente") {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupPageController() {
        pageControl.isUserInteractionEnabled = false

        self.pageViewController.view.topAnchor.constraint(equalTo: pageContainerView.topAnchor).isActive = true
        self.pageViewController.view.bottomAnchor.constraint(equalTo: pageContainerView.bottomAnchor).isActive = true
        self.pageViewController.view.trailingAnchor.constraint(equalTo: pageContainerView.trailingAnchor).isActive = true
        self.pageViewController.view.leadingAnchor.constraint(equalTo: pageContainerView.leadingAnchor).isActive = true
        
        pageViewController.didMove(toParentViewController: self)
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
        emptyView.backgroundColor = UIColor.white
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.alpha = 0
        emptyView.reloadButton.addTarget(self, action: #selector(tryAgain), for: .touchUpInside)
        view.addSubview(emptyView)
        emptyView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        emptyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        emptyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        emptyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    @objc func tryAgain() {
        self.viewModel.fetchMultipleChoices()
    }
    
    func setupButtons() {
        self.backButton.isHidden = true
        self.backArrowImageView.isHidden = true
    }
    
    // MARK: Navigation Item Setup
    
    func setupNavigationItem() {
        let backButton = UIBarButtonItem()
        backButton.title = " "
        
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CreateRefugeViewController.didTapCancelButton))
    }
    
    
    @objc func didTapCancelButton() {
        let alertController = UIAlertController(title: "¿Salir del formulario de creación?", message: "La información ingresada va a ser eliminada", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Salir", style: .destructive){ (action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Back/Next Actions

extension CreateRefugeViewController {
    
    @IBAction func didTapBackButton(sender: UIButton) {
        let nextPage = self.viewModel.currentPage-1
        changeToPage(numberOfPage: nextPage, direction: .reverse)
    }
    
    @IBAction func didTapNextButton(sender: UIButton) {
        if let currentPageViewModel = self.viewModel.currentPageViewModel, currentPageViewModel.isValid {
            let nextPage = self.viewModel.currentPage+1
            changeToPage(numberOfPage: nextPage, direction: .forward)
        }
    }
    
    func changeToPage(numberOfPage: Int, direction: UIPageViewControllerNavigationDirection) {
        if numberOfPage >= 0 && numberOfPage < self.viewModel.steps.count {
            self.view.endEditing(true)
            let viewController = self.viewControllerForStep(CreateRefugeSteps(rawValue: numberOfPage)!)
            self.viewModel.currentStep = self.viewModel.steps[numberOfPage]
            self.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
        }
    }
}

extension CreateRefugeViewController {
    func viewControllerForStep(_ step: CreateRefugeSteps) -> UIViewController {
        if !viewControllers.indices.contains(step.rawValue) {
            switch step {
            case .basicData:
                let viewController = RefugeBasicDataViewController()
                viewController.viewModel = self.viewModel.basicDataViewModel
                viewControllers.append(viewController)
                return viewController
            case .additionalData:
                let viewController = RefugeAdditionalDataViewController()
                viewController.viewModel = self.viewModel.additionalDataViewModel
                viewControllers.append(viewController)
                return viewController
            case .contactData:
                let viewController = RefugeContactDataViewController()
                viewController.viewModel = self.viewModel.contactDataViewModel
                viewControllers.append(viewController)
                return viewController
            case .censusData:
                let viewController = RefugeCensusDataViewController()
                viewController.viewModel = self.viewModel.censusDataViewModel
                viewControllers.append(viewController)
                return viewController
            case .infrastructureData:
                let viewController = RefugeInfrastructureDataViewController()
                viewController.viewModel = self.viewModel.infrastructureDataViewModel
                viewControllers.append(viewController)
                return viewController
            case .servicesData:
                let viewController  = RefugeServicesDataViewController()
                viewController.viewModel = self.viewModel.servicesDataViewModel
                viewControllers.append(viewController)
                return viewController
            }
        }
        return viewControllers[step.rawValue]
    }
}

extension CreateRefugeViewController: UINavigationBarDelegate{
    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
        return true
    }
}

extension CreateRefugeViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = viewControllers.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentIndex = pendingIndex {
                self.viewModel.currentStep = self.viewModel.steps[currentIndex]
                pageControl.currentPage = currentIndex
            }
        }
    }
}
