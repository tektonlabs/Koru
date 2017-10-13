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

class ListQuestionPageViewController: UIViewController {
    
    var progressView: UIProgressView!
    @IBOutlet weak var nextImage: UIImageView!
    @IBOutlet weak var previousImage: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var containerBottomView: UIView!
    @IBOutlet weak var previousButton: UIButton!
    var pageViewController: UIPageViewController!
    let viewModel = ListQuestionPageViewModel()
    fileprivate var pendingIndex: Int?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fillPageViewController()
        configureProgressBar()
        setupPage()
        styleUI()
        setupAction()
        setupNavigation()
        setupAction()
    }
    
    func setupPage() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        if let firstViewController = viewModel.orderedViewControllers.first as? QuestionViewController {
            changeNavigationTitle(title: firstViewController.viewModel.category.name!)
            pageViewController.setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageViewController.view)

            NSLayoutConstraint(item:  pageViewController.view, attribute: .top, relatedBy: .equal, toItem:  progressView, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
            
            pageViewController.view.bottomAnchor.constraint(equalTo: self.containerBottomView.topAnchor).isActive = true
            pageViewController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
            pageViewController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true

        }
    }
    
    func setupNavigation() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        let image = UIImage(named: "nav-back-arrow")
        let backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didTouchBackButton))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func didTouchBackButton() {
        viewModel.isPressBackButton = true
    }
    
    func configureProgressBar() {
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = ColorPalette.blueRefuge
        progressView.trackTintColor = ColorPalette.lightPurple
        progressView.translatesAutoresizingMaskIntoConstraints = false
        if viewModel.orderedViewControllers.count == 1 {
            progressView.progress = 1
        }
        self.view.addSubview(progressView)
        
        NSLayoutConstraint(item:  progressView, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1, constant: 20).isActive = true
        NSLayoutConstraint(item:  progressView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 2).isActive = true
        progressView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40).isActive = true
        progressView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40).isActive = true
        
    }
    
    //Mark: Action
    
    func setupAction() {
        viewModel.didChangePage = { [weak self] in
            self?.navigationItem.title = self?.viewModel.nextViewController.viewModel.category.name
        }
        
        viewModel.didChangeIndex = { [weak self] in
            if let index = self?.viewModel.index {
                if let count = self?.viewModel.orderedViewControllers.count {
              
                let progress = Float(index)/Float(count - 1)
                self?.progressView.progress = progress
                    
            if self?.viewModel.index == 0 {
                self?.previousButton.isHidden = true
                self?.previousImage.isHidden = true
            } else if index == count - 1 {
                self?.nextButton.isHidden = true
                self?.nextImage.isHidden = true
            } else if index > 0 {
                self?.previousButton.isHidden = false
                self?.previousImage.isHidden = false
                self?.nextButton.isHidden = false
                self?.nextImage.isHidden = false
                    }
                }
            }
        }
        
        viewModel.didTouchNextButton = { [weak self] in
            self?.viewModel.index += 1
            if let index = self?.viewModel.index {
                if let count = self?.viewModel.orderedViewControllers.count {
                    if index == 0 {
                        self?.progressView.progress = 0
                    } else {
                        let progress = Float(index)/Float(count - 1)
                        self?.progressView.progress = progress
                    }
                }
                if index == (self?.viewModel.orderedViewControllers.count)! - 1  {
                    self?.nextButton.isHidden = true
                    self?.nextImage.isHidden = true
                }
                
                if index > 0 {
                    self?.previousButton.isHidden = false
                    self?.previousImage.isHidden = false
                }
            }
        }
        
        viewModel.didTouchPreviousButton = { [weak self] in
            self?.viewModel.index -= 1
            if let index = self?.viewModel.index {
                if let count = self?.viewModel.orderedViewControllers.count {
                    if index == 0 {
                        self?.progressView.progress = 0
                    } else {
                        let progress = Float(index)/Float(count - 1)
                        self?.progressView.progress = progress
                    }
                }
                if index == 0  {
                    self?.previousImage.isHidden = true
                    self?.previousButton.isHidden = true
                }
                
                if index < (self?.viewModel.orderedViewControllers.count)! - 1  {
                    self?.nextButton.isHidden = false
                    self?.nextImage.isHidden = false
                }
            }
        }
        
        viewModel.didTouchBackButton = { [weak self] in
            self?.verifyBackButton()
        }
        
        viewModel.didVerifyFormulary = { [weak self] in
            self?.verifyFormulary()
        }
        
        viewModel.didSendQuestionSuccess = { [weak self] in
            self?.successSendQuestionsAlert()
        }
        
        viewModel.wasNotSummited = { [weak self] in
            self?.noSummitedQuestionFormAlert()
        }
    }
    
    func successSendQuestionsAlert() {
        let alertController = UIAlertController(title: "El formulario fue enviado exitosamente", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Aceptar", style: .default) { (press) in
            self.navigationController!.popToRootViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func noSummitedQuestionFormAlert() {
        let alertController = UIAlertController(title: "No se pudo enviar el formulario.", message: "La aplicación lo intentará de nuevo una vez que se establezca una conexión a internet.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Aceptar", style: .default) { (press) in
            self.navigationController!.popToRootViewController(animated: true)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func verifyBackButton() {
        let alertController = UIAlertController(title: "¿Desechar formulario?", message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Desechar", style: .default) { (press) in
            self.navigationController!.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)     
    }
    
    
    func changeNavigationTitle(title: String) {
        self.navigationItem.title = title
    }
    
    
    func styleUI() {
        containerBottomView.backgroundColor = ColorPalette.ultraLightGray
        previousButton.setTitleColor(ColorPalette.darkGray, for: .normal)
        previousButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        previousButton.setTitle("Atrás", for: .normal)
        previousButton.addTarget(self, action: #selector(didTouchPreviusButton), for: .touchUpInside)
        nextButton.setTitleColor(ColorPalette.darkGray, for: .normal)
        nextButton.setTitle("Saltar", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        nextButton.addTarget(self, action: #selector(didTouchNextButton), for: .touchUpInside)
        if viewModel.orderedViewControllers.count == 1 {
            previousImage.isHidden = true
            previousButton.isHidden = true
            nextImage.isHidden = true
            nextButton.isHidden = true
        } else {
            previousButton.isHidden = true
            previousImage.isHidden = true
        }
    }
    
    @objc func didTouchPreviusButton() {
        let viewController = viewModel.orderedViewControllers[viewModel.index - 1] as! QuestionViewController
        viewModel.didChangePage(nextViewController: viewController)
        pageViewController.setViewControllers([viewController], direction: .reverse, animated: true) { (finished) in
            self.viewModel.isPrevious = true
        }
    }
    
    @objc func didTouchNextButton() {
        let nextIndex = viewModel.index + 1
        if nextIndex < viewModel.orderedViewControllers.count {
            let viewController = viewModel.orderedViewControllers[viewModel.index + 1] as! QuestionViewController
            viewModel.didChangePage(nextViewController: viewController)
            pageViewController.setViewControllers([viewController], direction: .forward, animated: true) { (finished) in
                self.viewModel.isNext = true
            }
        }

    }
    
    func verifyFormulary() {
        let alertController = UIAlertController(title: "Para enviar el formulario, responde almenos una pregunta", message: "", preferredStyle: .alert)
            
        let okAction = UIAlertAction(title: "Confirmar", style: .default, handler: nil)
        alertController.addAction(okAction)
            
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ListQuestionPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewModel.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewModel.orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return viewModel.orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewModel.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = viewModel.orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return viewModel.orderedViewControllers[nextIndex]
    }
}

extension ListQuestionPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        pendingIndex = viewModel.orderedViewControllers.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
        if let currentIndex = pendingIndex, let previousIndex = viewModel.orderedViewControllers.index(of: previousViewControllers.first!) {
            if currentIndex != previousIndex {
            let currentViewController = viewModel.orderedViewControllers[currentIndex] as! QuestionViewController
                viewModel.index = currentIndex
                viewModel.didChangePage(nextViewController: currentViewController)
                }
            }
        }
    }
}
