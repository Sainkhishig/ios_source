//
//  UserInfo.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 12/6/20.
//

import Foundation
struct UserInfo: Decodable{
    var uid: Int?
    var username: String?
    var company_id: Int?
    var web: String?
    var db: String?
    var name: String?
    
    init(){}
    init(uid: Int, username: String, company_id: Int, web: String, db: String) {
        self.uid = uid
        self.username = username
        self.company_id = company_id
        self.web = web
        self.db = db
    }
    
    enum CodingKeys: String, CodingKey {
        case company_id, db, name, uid, username
        case web = "web.base.url"
    }
}
