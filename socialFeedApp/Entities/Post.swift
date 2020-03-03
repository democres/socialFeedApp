//
//  Post.swift
//  socialFeedApp
//
//  Created by David Figueroa on 3/03/20.
//  Copyright © 2020 David Figueroa. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class Post: Object, Mappable {

    @objc dynamic var id: Int = 0
    @objc dynamic var link: String?
    @objc dynamic var network: String?
    @objc dynamic var date: String?
    @objc dynamic var author: Author?
    @objc dynamic var text: String?
    @objc dynamic var attachmentHeight: Int = 0
    @objc dynamic var attachmentWidth: Int = 0
    @objc dynamic var attachmentPictureLink: String?
    
    //MARK: - Mappable
    required convenience init?(map: Map) {
          self.init()
    }
    
    func mapping(map: Map) {
        link <- map["link"]
        network <- map["network"]
        date <- map["date"]
        author <- map["author"]
        text <- map["text.plain"]
        attachmentHeight <- map["attachment.height"]
        attachmentWidth <- map["attachment.width"]
        attachmentPictureLink <- map["attachment.picture-link"]
    }
    
}
