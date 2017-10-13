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

class UserManager {
    
    static let sharedInstance = UserManager()
    
    var currentUser: User? {
        didSet {
            if currentUser != nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLoginNotification), object: nil)
            }
        }
    }
    
    private init(){
        currentUser = NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as? User
    }
    
    var hasCurrentUser: Bool {
        return UserManager.sharedInstance.currentUser != nil
    }
    
    func getInformationFromUser() -> User {
        return NSKeyedUnarchiver.unarchiveObject(withFile: User.ArchiveURL.path) as! User
    }
    
    func saveUser() {
        NSKeyedArchiver.archiveRootObject(UserManager.sharedInstance.currentUser!, toFile: User.ArchiveURL.path)
    }
    
    func deleteUser(){
        do {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.didLogoutNotification), object: nil)
            try FileManager.default.removeItem(atPath: User.ArchiveURL.path)
        } catch let error as NSError {
            print("Failed to remove user: \(error)")
        }
    }
}
