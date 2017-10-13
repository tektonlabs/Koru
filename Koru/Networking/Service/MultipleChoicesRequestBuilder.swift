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

import Foundation
import Moya

enum MultipleChoicesRequestBuilder {
    
    case list
    
}

extension MultipleChoicesRequestBuilder: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    
    var baseURL: URL {
        let apiURL = NetworkingSetup.environmentRoute()
        return URL(string: apiURL)!
    }
    
    var path: String {
        switch self {
        case .list:
            return MultipleChoicesBuilderPaths.list
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestPlain
    }
    
    static let multipleChoicesServiceEndpointClosure = { (target: MultipleChoicesRequestBuilder) -> Endpoint<MultipleChoicesRequestBuilder> in
        let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
        
        switch target {
        case .list:
            return NetworkingSetup.headers(for: target)
        }
    }
    
    
}

struct MultipleChoicesBuilderPaths {
    
    static let list = "/multiple_choice_ids"
    
}
