//
//  HomeFeedInteractor.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

class HomeFeedInteractor: HomeFeedInteractorProtocol{
    
    var interactorOutputDelegate: HomeFeedInteractorDelegate?
        
    let moyaProvider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])
    
    func getSocialPosts() -> Observable<[Post]>{
                
        return moyaProvider.rx.request(.getSocialMediaPosts)
                .debug()
                .filterSuccessfulStatusCodes()
                .asObservable()
                .map{ response -> [Post] in
                    let dataAux = try JSONSerialization.jsonObject(with: response.data, options: [])
                    if let json = dataAux as? [[String: Any]] {
                        if let postArray = Mapper<Post>().mapArray(JSONObject: json){
                            return postArray
                        }
                    }
                    return [Post]()
                 }
    }
        
}
