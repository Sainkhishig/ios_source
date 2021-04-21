//
//  IrModule.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 1/17/21.
//

import Foundation

class IrModule : Decodable{
    var id: Int = 0
    var name: String = ""
    var state: String = ""
    
    init(){}
    
    init(id: Int, name: String, state: String) {
        self.id = id
        self.name = name
        self.state = state
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, state
    }
}
