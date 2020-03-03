//
//  Author.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import ObjectMapper
import RealmSwift

class Author: Object, Mappable {

    @objc dynamic var isVerified: Bool = false
    @objc dynamic var name: String?
    @objc dynamic var pictureLink: String?
    @objc dynamic var account: String?
    
    
    //MARK: - Mappable
    required convenience init?(map: Map) {
          self.init()
    }
    
    func mapping(map: Map) {
        isVerified <- map["is-verified"]
        name <- map["name"]
        pictureLink <- map["picture-link"]
        account <- map["account"]
    }
    
}
