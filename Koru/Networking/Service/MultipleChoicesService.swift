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
import Moya_ModelMapper

class MultipleChoicesService {
    static func list(completion: @escaping (_ multipleChoices: RefugeFormMultipleChoices?,_ error: Swift.Error?) -> Void) {
        
        let provider = MoyaProvider<MultipleChoicesRequestBuilder>(endpointClosure: MultipleChoicesRequestBuilder.multipleChoicesServiceEndpointClosure)
        provider.request(.list) { (result) in
            
            switch result {
            case .success(let success):
                do {
                    let multipleChoices = try success.map(to: RefugeFormMultipleChoices.self )
                    completion(multipleChoices, nil)
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
