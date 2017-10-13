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

import Foundation
import UIKit

class NotificationManager {
    
    static let sharedInstance = NotificationManager()

    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let notificationSendQuestionForm = "sendQuestionForm"
    let notificationFailureSendQuestionForm = "failureSendQuestionForm"
    func registerDidLoginNotification() {
        let notificationLoginUser = NSNotification.Name(rawValue: User.didLoginNotification)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedAuthenticationNotifaction(notification:)), name: notificationLoginUser, object: nil)
        
        let notificationLoginEnumeratorUser = NSNotification.Name( rawValue: EnumeratorUser.didLoginNotification)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receivedAuthenticationNotifaction(notification:)), name: notificationLoginEnumeratorUser, object: nil)
    }
    
    func postNotificationSendAllQuestionForm() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationSendQuestionForm), object: nil)
    }
    
    func postNotificationFailureSendQuestionForm() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationFailureSendQuestionForm), object: nil)
    }
    
    
    @objc private func receivedAuthenticationNotifaction(notification : NSNotification) {
        
        OperationQueue.main.addOperation { () -> Void in
            
            let snapshot = self.appDelegate.window!.snapshotView(afterScreenUpdates: true)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()!
            self.appDelegate.window?.rootViewController = initialViewController
            
            let loginSnapshot = initialViewController.view.snapshotView(afterScreenUpdates: true)
            initialViewController.view.addSubview(snapshot!)
            initialViewController.view.addSubview(loginSnapshot!)
            
            loginSnapshot?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            loginSnapshot?.alpha = 0
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                loginSnapshot?.transform = CGAffineTransform.identity
                loginSnapshot?.alpha = 1
            }, completion: { (completed) -> Void in
                snapshot?.removeFromSuperview()
                loginSnapshot?.removeFromSuperview()
            })
        }
    }
}
