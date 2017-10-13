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
import Moya
import Moya_ModelMapper

class CommitteeService {

    static func search(_ text: String, completion: @escaping (_ committees: [Committee]?,_ error: Swift.Error?) -> Void) {
        
        let provider = MoyaProvider<CommitteeRequestBuilder>(endpointClosure: CommitteeRequestBuilder.committeeServiceEndpointClosure)
        provider.request(.searchCommittee(filter: text)) { (result) in
            
            switch result {
            case .success(let success):
                do {
                    let committes = try success.map(to: [Committee].self) 
                    
                    completion(committes, nil)
                } catch {
                    completion(nil, error)
                }
                break
            case .failure(let error):
                completion(nil, error)
                break
            }
        }
    }
}
