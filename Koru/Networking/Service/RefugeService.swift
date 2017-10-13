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

class RefugeService {
    static func getRefuges(location: Location?, limit: String, offset: String, text: String, completion: @escaping (_ character: [Refuge]?,_ error: Swift.Error?) -> Void) {
        
        let provider = MoyaProvider<RefugeRequestBuilder>(endpointClosure: RefugeRequestBuilder.refugeServiceEndpointClosure)
        provider.request(.listAllRefugeRequest(lat: location?.getLatitude(), long: location?.getLongitude(), limit: limit, offset: offset, text: text)) { (result) in
            
            switch result {
            case .success(let success):
                do {
                    let refuges = try success.map(to: [Refuge].self )
                    let sortedRefuges = refuges.sorted{ $0.sortedName < $1.sortedName }
                    
                    completion(sortedRefuges, nil)
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
    
    static func sendQuestionFromShelter(questions: [[String: Any]], refuge: Refuge, dni: String, date: Int, completion: @escaping  (_ response: String?, _ error: Swift.Error?) -> Void) {
        
        let provider = MoyaProvider<RefugeRequestBuilder>(endpointClosure: RefugeRequestBuilder.refugeServiceEndpointClosure)
        provider.request(.questionsFromShelter(questions: questions, refuge: refuge, date: date, dni: dni)) { (result) in
            
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    completion("success", nil)
                } else {
                    completion("error", nil)
                }
                break
            case .failure(let error):
                completion("failure", error)
                break

            }
        }
    }
    
    static func createRefuge(refugeForm: [String: Any], completion: @escaping  (_ response: String?, _ error: Swift.Error?) -> Void) {
        let provider = MoyaProvider<RefugeRequestBuilder>(endpointClosure: RefugeRequestBuilder.refugeServiceEndpointClosure, plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)] )
    
        provider.request(.createRefuge(refugeForm: refugeForm)) { (result) in
            switch result {
            case .success(let success):
                if success.statusCode == 200 {
                    completion("success", nil)
                } else {
                    let error = try? success.map(to: SAError.self, keyPath: "error")
                    completion("error", error)
                }
            case .failure(let error):
                completion("failure", error)
            }
        }
    
    }
}
