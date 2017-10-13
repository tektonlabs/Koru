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

class EnumeratorUserManager {
    
    static let sharedInstance = EnumeratorUserManager()
    
    var currentEnumeratorUser: EnumeratorUser? {
        didSet {
            if currentEnumeratorUser != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: EnumeratorUser.didLoginNotification), object: nil)
            }
        }
    }
    
    private init(){
        currentEnumeratorUser = NSKeyedUnarchiver.unarchiveObject(withFile: EnumeratorUser.ArchiveURL.path) as? EnumeratorUser
    }
    
    var hasCurrentUser: Bool {
        return EnumeratorUserManager.sharedInstance.currentEnumeratorUser != nil
    }
    
    func getInformationFromUser() -> EnumeratorUser {
        return NSKeyedUnarchiver.unarchiveObject(withFile: EnumeratorUser.ArchiveURL.path) as! EnumeratorUser
    }
    
    func saveUser() {
        NSKeyedArchiver.archiveRootObject(EnumeratorUserManager.sharedInstance.currentEnumeratorUser!, toFile: EnumeratorUser.ArchiveURL.path)
    }
    
    func deleteUser(){
        do {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: EnumeratorUser.didLogoutNotification), object: nil)
            try FileManager.default.removeItem(atPath: EnumeratorUser.ArchiveURL.path)
        } catch let error as NSError {
            print("Failed to remove user: \(error)")
        }
    }

}
