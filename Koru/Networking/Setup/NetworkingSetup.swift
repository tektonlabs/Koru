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
import Moya

class NetworkingSetup {
    
    static private var headers = [String : String]()
    
    static func environmentRoute() -> String {
        guard let plistPath = Bundle.main.path(forResource: AppType.current.infoPlistName, ofType: "plist"),
            let plistDictionary = NSDictionary(contentsOfFile: plistPath)
            else { fatalError("Plist file can't be read") }
        guard let defaultRoute = plistDictionary.object(forKey: "Environment route") as? String else {
            fatalError("Configure Enviroment route on plist file.")
        }
        return defaultRoute
    }
    
    static func headers<T: TargetType>(for target: T) -> Endpoint<T> {
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            headers["Content-Type"] = "application/json; charset=utf-8"
        
        return defaultEndpoint.adding(newHTTPHeaderFields: headers)
    }
}
