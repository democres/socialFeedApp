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
import RealmSwift

class HomeFeedInteractor: HomeFeedInteractorProtocol{
    
    weak var interactorOutputDelegate: HomeFeedInteractorDelegate?
        
    let moyaProvider = MoyaProvider<APIService>(plugins: [NetworkLoggerPlugin()])
    
    func getSocialPosts(index: Int) -> Observable<[Post]>{
        
        return moyaProvider.rx.request(.getSocialMediaPosts(index: index))
                .debug()
                .filterSuccessfulStatusCodes()
                .asObservable()
                .map{ response -> [Post] in
                    let dataAux = try JSONSerialization.jsonObject(with: response.data, options: [])
                    if let json = dataAux as? [[String: Any]] {
                        if let postArray = Mapper<Post>().mapArray(JSONObject: json){
                            self.storeData(postArray: postArray)
                            return postArray
                        }
                    }
                    return self.fetchLocalData()
                 }
    }
    
    
    func fetchLocalData() -> [Post] {
        var postArray = [Post]()
        do {
            let realm = try Realm()
            realm.objects(Post.self).forEach { post in
                postArray.append(post)
            }
        } catch let error {
            print(error)
        }
        return postArray
    }
    
    func storeData(postArray: [Post]){
        do {
            let realm = try Realm()
            try realm.write {
                postArray.forEach { post in
                    realm.add(post)
                }
            }
        } catch let error {
            print(error)
        }
    }
    
        
}
