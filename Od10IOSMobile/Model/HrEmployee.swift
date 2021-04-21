//
//  HrEmployee.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 12/6/20.
//

import Foundation

class HrEmployee{
    var name: String = ""
    var id: Int = 0
    var display_name: String = ""
    
    init(id:Int , name:String, display_name:String){
        self.id = id
        self.name = name
        self.display_name = display_name
    }
}
