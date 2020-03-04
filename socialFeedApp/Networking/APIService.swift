//
//  APIService.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Moya

enum APIService {
    case getSocialMediaPosts(index: Int)
}

extension APIService: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getSocialMediaPosts(let index):
            return URL(string: "https://storage.googleapis.com/cdn-og-test-api/test-task/social/\(String(index)).json")!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Method {
        switch self {
        case .getSocialMediaPosts:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getSocialMediaPosts:
            return [String:Any]()
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
