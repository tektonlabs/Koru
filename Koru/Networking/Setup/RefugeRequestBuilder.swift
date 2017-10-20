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

enum RefugeRequestBuilder {
    
    case listAllRefugeRequest(lat: String?, long: String?, limit: String, offset: String, text: String)
    case questionsFromShelter(questions: [[String: Any]], refuge: Refuge, date: Int, dni: String)
    case createRefuge(refugeForm: [String: Any])
}

extension RefugeRequestBuilder : TargetType {
    
    var headers: [String : String]? {
        var defaultHeaders = [String: String]()
        defaultHeaders["Content-Type"] = "application/json; charset=utf-8"
        return defaultHeaders
    }
    
    var baseURL: URL {
        let apiURL = NetworkingSetup.environmentRoute()
        guard let url = URL(string: apiURL) else {
            fatalError("URL has wrong format \(apiURL).")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .listAllRefugeRequest:
            return RefugeRequestBuilderPaths.refuge
        case .questionsFromShelter( _, let refuge, _, _):
            return "/\(refuge.id!)\(RefugeRequestBuilderPaths.quesition)"
        case .createRefuge:
            return RefugeRequestBuilderPaths.refuge
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .listAllRefugeRequest:
            return .get
        case .questionsFromShelter:
            return .post
        case .createRefuge:
            return .post
           }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .listAllRefugeRequest(let lat, let long, let limit, let offset, let text):
            if let lat = lat, let long = long {
                return ["limit" : "\(limit)",
                    "offset"  : "\(offset)",
                    "lat"  : "\(lat)",
                    "long" : "\(long)",
                    "query": "\(text)"]
            } else {
                return ["limit" : "\(limit)",
                    "offset"  : "\(offset)",
                    "query": "\(text)"]
            }
            
        case .questionsFromShelter(let questions, _, let date, let dni):
            return ["dni": dni,
            "questions": questions,
            "current_date": date]
        case .createRefuge(refugeForm: let refugeForm):
            return refugeForm
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .listAllRefugeRequest(let lat, let long, let limit, let offset, let text):
            var parameters = [String: String]()
            if let lat = lat, let long = long {
                parameters = ["limit" : "\(limit)",
                    "offset"  : "\(offset)",
                    "lat"  : "\(lat)",
                    "long" : "\(long)",
                    "query": "\(text)"]
            } else {
                parameters = ["limit" : "\(limit)",
                    "offset"  : "\(offset)",
                    "query": "\(text)"]
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .questionsFromShelter(let questions, _, let date, let dni):
            return .requestParameters(parameters: ["dni": dni,
                                                   "questions": questions,
                                                   "current_date": date], encoding: JSONEncoding.default)
        case .createRefuge(refugeForm: let refugeform):
            return .requestParameters(parameters: refugeform, encoding: JSONEncoding.default)
        }
    }
    
    static let refugeServiceEndpointClosure = { (target: RefugeRequestBuilder) -> Endpoint<RefugeRequestBuilder> in
        _ = MoyaProvider.defaultEndpointMapping(for: target)
        
        switch target {
        case .listAllRefugeRequest:
            return NetworkingSetup.headers(for: target)
        case .questionsFromShelter:
            return NetworkingSetup.headers(for: target)
        case .createRefuge:
            return NetworkingSetup.headers(for: target)
        }
    }
}

struct RefugeRequestBuilderPaths {
    static let refuge = ""
    static let quesition = "/responses"
}


