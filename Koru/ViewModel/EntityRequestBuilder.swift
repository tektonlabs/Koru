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

enum EntityRequestBuilder {
    
    case listEntity(refuge: Refuge)
    
}

extension EntityRequestBuilder: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
        
    var baseURL: URL {
        let apiURL = NetworkingSetup.environmentRoute()
        return URL(string: apiURL)!
    }
        
    var path: String {
        switch self {
            case.listEntity(let refuge):
                return  "/\(refuge.id!)" + EntityRequestBuilderPaths.endEntity
            }
        }
        
        var method: Moya.Method {
            switch self {
            case .listEntity:
                return .get
            }
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case .listEntity(refuge: _):
                return .requestParameters(parameters: ["limit" : ""], encoding: URLEncoding.queryString)
            
            }
        }
        
        static let entitySeviceEndpointClosure = { (target: EntityRequestBuilder) -> Endpoint<EntityRequestBuilder> in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
                
            switch target {
                case .listEntity:
                    return NetworkingSetup.headers(for: target)
            }
        }
        
    
}

struct EntityRequestBuilderPaths {
        
    static let endEntity = "/entities"

}

