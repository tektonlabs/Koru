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

class InitalPageViewController: UIViewController {

    @IBOutlet weak var monitorButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleUI()
        fillUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    func styleUI() {
        monitorButton.layer.cornerRadius = 2
        monitorButton.backgroundColor = ColorPalette.blueButton
        monitorButton.setTitleColor(UIColor.white, for: .normal)
        monitorButton.layer.masksToBounds = false
        monitorButton.layer.shadowColor = UIColor.black.cgColor
        monitorButton.layer.shadowOpacity = 0.5
        monitorButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        monitorButton.layer.shadowRadius = 1
        monitorButton.addTarget(self, action: #selector(didTouchMonitorButton), for: .touchUpInside)
        
        registerButton.layer.cornerRadius = 2
        registerButton.backgroundColor = ColorPalette.blueButton
        registerButton.setTitleColor(UIColor.white, for: .normal)
        registerButton.layer.masksToBounds = false
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOpacity = 0.5
        registerButton.layer.shadowOffset = CGSize(width: -1, height: 1)
        registerButton.layer.shadowRadius = 1
        registerButton.addTarget(self, action: #selector(didTouchRegisterButton), for: .touchUpInside)
        
        containerView.backgroundColor = ColorPalette.blueRefuge
        
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        titleLabel.textColor = UIColor.white
        
    }
    
    func fillUI() {
        monitorButton.setTitle("Monitorear", for: .normal)
        registerButton.setTitle("Empadronar", for: .normal)
        
        titleLabel.text = "SEGUNDOS AUXILIOS"
    }
    
    @objc func didTouchMonitorButton() {
        let mainStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
        let monitorearViewController = mainStoryboard.instantiateViewController(withIdentifier: "monitorViewController") as! MonitorViewController
        self.navigationController?.pushViewController(monitorearViewController, animated: true)
    }
    
    @objc func didTouchRegisterButton() {
        let mainStoryboard = UIStoryboard(name: "Authenticate", bundle: nil)
        let registrarViewController = mainStoryboard.instantiateViewController(withIdentifier: "takeRegisterViewController") as! TakeRegisterViewController
        self.navigationController?.pushViewController(registrarViewController, animated: true)
    }
    
}
